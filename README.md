# ParameterSubstitution

Handles parsing an input strings with embedded substitution parameters and replacing them with values from a provided mapping.  
The substitution can be formatted using a syntax that looks like method calls.  For example, the following will return
"it is a WINDY day".

```
  ParameterSubstitution.evaluate( input: "it is a <weather.upper> day", mapping: { "weather" => "windy" } )
```

  The call to upper formats the input by calling the format method on the class **Reports::ColumnFormat::Upper**.

  Formats can take arguments and can be chained.  For example, the following formats the time using strftime to find just am or pm, 
  and then comares that to say morning or evening.

```
  ParameterSubstitution.evaluate( 
    input: "good <time.date_time_strftime("%p").compare_string("am", "morning", "evening")>", 
    mapping: { "time" => Time.now.to_s } )
  
```    

   The substitution behavior is very configurable because it is used in many different environments.  The configuration is passed
   through named arguments to the evaluate method.  These named arguments have defaults that should work for most conditions.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'parameter_substitution'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install parameter_substitution


## Design

[Design Drawing](https://docs.google.com/drawings/d/1A1nQVw_oh0dfN52pHNX19NtuEB5RY7RpM6Fv9bToGV4/edit)

![ParameterSubstitutionDesign](./parameter_subsitution_design.png)

The **ParameterSubstituion** module exposes the public interface for this subsystem.  All other classes are internal and should 
  be considered private.
  
When evaluate is called, the module constructs a **Parser** to parse the input into a syntax tree.  Parser is implemented using the 
[Parslet](http://kschiess.github.io/parslet/) gem, which is pretty great.   The output from the parser is a ruby hash that describes the input.
  
The module then constructs a **Transform** to convert this syntax tree to an **Expression** that can be evaluated.  
An Expression has a list of sub expressions that are either **TextExpressions**, which simply returns the text when evaluated, or 
    **SubstitutionExpressions** which return the formatted value from the mapping when called.  
    
SubstitutionExpressions have a list of **MethodCallExpressions**.   These expressions call the corresponding class in 'app/models/reporting/column_formats'  

**Context** is a helper class that is used to pass around the set of options for the current parameter substitution.  

## Next Steps

If you are working in this subsystem, consider the following improvements while you work:

 * The performance is pretty slow.  I believe the performance is suffering because it is building a parser for every request.
 Parsers take a couple input parameters, but really there are just a couple permutations.  (What type of open and close characters, 
 are unbalanced closes allowed.)  We could have a parser factory that kept the parsers that were constructed for each permutation.
 * The error handling for missing methods could be better.  We raise the first error instead of all of the errors, and we could
 provide the location for each validation failure.
 * It would be nice if the column format methods provided a validation for their arguments.
 * The behavior for TokenReplacement.substitute_params is very odd.  Missing substitution parameters and nil subsitution parameters 
 are handled differently for keys vs values and if the subtitution is the full string or part of the string.  I don't think this behavior
 is desired by customers and a more consistent handling would make for much cleaner code.  (See any code that is handling the :raw destination format)

## Running tests...
```
bundle exec rake test
```
## Integration Testing
When we introduced this subsystem, we created a way to confirm that the behavior is the same with the new code as it is in production.  
 This may be helpful in future iterations.  The **ActivityCapture** class (script/integration_testing/activity_capture) can be used to 
 grab all method calls matching a pattern and save the inputs and the outputs to a yml file.
   
   The following uses AcivityCapture to capture parameter substitution activity for the trackign pixesl associated with the last 1000 
   calls in production. 
 
To re-run this test:
 
1) From script console on a production server, paste in the contents of script/ingegration_testing/activity_capture.rb, and then the following:
 
 ```
require "./script/integration_testing/activity_capture"

module Webhooks
  module FireStandard
    def get_webhook_request(call)      
      request = case tracking_pixel_method
      when :GET, :GoogleAnalytics
        StandardRequest.new(:get, :form_url, call, self)
      when :POST
        StandardRequest.new(:post, :form_url, call, self)
      when :XML
        StandardRequest.new(:post, :xml, call, self)
      when :JsonPost
        StandardRequest.new(:post, :json, call, self)
      when :Plugin
        "#{plugin_name.classify}::Webhook".constantize.new(call, self)
      else
        nil
      end
    end
  end
end


# Find the last call for all active pixels and the most recent 500 calls.  
# We are skipping SaleForce because they do not use substitution.
pixel_xuids = TrackingPixel.active.where.not(last_processed_transaction_xuid: "").where.not(tracking_pixel_method: :SalesForce).pluck(:last_processed_transaction_xuid)
recent_call_xuids = Call.last(500).map { |c| c.xuid }
xuids = (pixel_xuids + recent_call_xuids).sort.uniq  
calls = xuids.map { |xuid| Call.find_by_xuid(xuid) rescue nil }.compact; nil

# Capture substitution activity for all pixels on all of these calls... 
capture_map = {
  TokenReplacement => [:replace_tokens, :replace_xml_tokens, :find_tokens, :substitute_params],
  JsonParamsSubstituter => [:substitute]
}

ActivityCapture.save_activity("token_replacement_activity.yml", capture_map) do
  calls.each do |c|
    tps = (c.send(:unreliable_webhooks) + c.send(:reliable_webhooks)).flatten.select { |tp| tp.is_active? }
    tps.each do |tp|
      begin
        request = tp.get_webhook_request(c)
        request&.send(:info)
      rescue => ex
        puts ex.inspect
      end
    end
  end
end

```

2) Use scp to copy the "token_Replacement_activity.yml" file to your local web repo.

3) On script/console from your local web repo, run the following:
 
```
require "./script/integration_testing/activity_capture"
capture_map = {
  TokenReplacement => [:replace_tokens, :replace_xml_tokens, :find_tokens, :substitute_params],
  JsonParamsSubstituter => [:substitute]
}

ActivityCapture.diff_activity("log/token_replacement_activity.yml", capture_map)
```

The above will re-run the above commands on the new code and report any differences.  To save space, the output does not print the 
full input parameters, but it does report the index.  To find the input you can use the following:     

```
captures = YAML.load(File.read("token_replacement_activity.yml")); nil
ap captures[index]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/parameter_substitution.

