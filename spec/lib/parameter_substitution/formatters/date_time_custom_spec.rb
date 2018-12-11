# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/date_time_custom'

describe ParameterSubstitution::Formatters::DateTimeCustom do
  context "Date Time Custom formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::DateTimeCustom
      allow(Time).to receive(:now).and_return(Time.new(2017, 7, 9, 19, 0, 0))
      expect(Time.now.dst?).to be(true)
    end

    it "have a key" do
      expect(@format_class.key).to eq("date_time_custom")
    end

    it "report that it has parameters" do
      expect(@format_class.has_parameters?).to eq(true)
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Formats a Date String with the provided formatting, converts it's time zone, and then converts it to the desired formatting string.")
    end

    context "#format" do
      it "support converting times" do
        example_time_string = "07/29/2017 11:44:27 PM -0700"
        format = @format_class.new("%m/%d/%Y %I:%M:%S %p %z", "%m/%d/%Y/%H/%M/%S %z", "", "Mountain Time (US & Canada)")

        expect(format.format(example_time_string)).to eq("07/30/2017/00/44/27 -0600")
      end

      it "receive a formatted string, convert it to GMT, then re-format" do
        example_time_string = "07/29/2017 11:44:27 PM -0600"
        format = @format_class.new("%m/%d/%Y %I:%M:%S %p", "%Y-%m-%dT%H:%M:%S%:z", "", "UTC")

        expect(format.format(example_time_string)).to eq("2017-07-29T23:44:27+00:00")
      end

      it "raise an argument error on format when configured with an invalid time zone" do
        example_time_string = "07/29/2017 11:44:27 PM -0600"
        format = @format_class.new("%m/%d/%Y %I:%M:%S %p", "%Y-%m-%dT%H:%M:%S%:z", "", "Mars (US & Canada)")

        expect { format.format(example_time_string) }.to raise_error(ArgumentError, "Invalid Timezone: Mars (US & Canada)")
      end

      it "not handle invalid date" do
        format = @format_class.new("%Y-%m-%d %H:%M:%S %:z", "%m/%d/%Y/%H/%M/%S", nil, "UTC")
        expect(format.format(9_999_999_999_999_999_999_999)).to eq("")
      end

      it "assumes the current time zone if no time zone is in example or as argument" do
        Time.zone = "Pacific Time (US & Canada)"

        example_time_string = "07/29/2017 11:44:27 PM"
        format = @format_class.new("%m/%d/%Y %I:%M:%S %p", "%m/%d/%Y/%H/%M/%S %z", nil, Time.zone)

        expect(format.format(example_time_string)).to eq("07/29/2017/16/44/27 -0700")
      end

      it "only update formatting nil is passed as from_time_zone / to_time_zone" do
        example_time_string = "07/29/2017 11:44:27 PM -0600"
        format = @format_class.new("%m/%d/%Y %I:%M:%S %p %z", "%Y-%m-%dT%H:%M:%S%:z", nil, nil)

        expect(format.format(example_time_string)).to eq("2017-07-29T23:44:27-06:00")
      end

      it "receive a formatted string without a time zone, inject a time zone, convert it to Time.zone, and then re-format" do
        Time.zone = "Pacific Time (US & Canada)"

        example_time_string = "07/29/2017 11:44:27 AM"
        format = @format_class.new("%m/%d/%Y %I:%M:%S %p %z", "%Y-%m-%dT%H:%M:%S%:z", "Georgetown", "Pacific Time (US & Canada)")

        expect(format.format(example_time_string)).to eq("2017-07-29T08:44:27-07:00")
      end

      it "receive a formatted string without a time zone, inject a time zone, convert it to UTC, and then re-format" do
        example_time_string = "07/29/2017 11:44:27 AM"
        format = @format_class.new("%m/%d/%Y %I:%M:%S %p %z", "%Y-%m-%dT%H:%M:%S%:z", "Georgetown", "UTC")

        expect(format.format(example_time_string)).to eq("2017-07-29T15:44:27+00:00")
      end

      it "display blank for different (non-date) types" do
        format_with_nil_value = @format_class.new("%Y-%m-%d %H:%M:%S %:z", "%m/%d/%Y/%H/%M/%S", nil, "UTC")
        expect(format_with_nil_value.format(nil)).to eq("")

        format_with_integer_value = @format_class.new("%Y-%m-%d %H:%M:%S %:z", "%m/%d/%Y/%H/%M/%S", nil, "UTC")
        expect(format_with_integer_value.format(1)).to eq("")
      end

      it "account for daylight savings when formatting" do
        expect(Time.now.dst?).to be(true)

        example_time_string = "07/29/2017 11:44:27 AM"
        format = @format_class.new("%m/%d/%Y %I:%M:%S %p %z", "%Y-%m-%dT%H:%M:%S%:z", "Pacific Time (US & Canada)", "UTC")

        expect(format.format(example_time_string)).to eq("2017-07-29T18:44:27+00:00")

        allow(Time).to receive(:now).and_return(Time.new(2017, 12, 1, 19, 0, 0))

        expect(Time.now.dst?).to be(false)

        format = @format_class.new("%m/%d/%Y %I:%M:%S %p %z", "%Y-%m-%dT%H:%M:%S%:z", "Pacific Time (US & Canada)", "UTC")

        expect(format.format(example_time_string)).to eq("2017-07-29T19:44:27+00:00")
      end

      it "handle an unrecognized from_time_zone" do
        example_time_string = "07/29/2017 11:44:27 AM"
        invalid_from_time_zone = "Mars (US & Canada)"
        format = @format_class.new("%m/%d/%Y %I:%M:%S %p %z", "%Y-%m-%dT%H:%M:%S%:z", invalid_from_time_zone, "UTC")

        expect { format.format(example_time_string) }.to raise_error(RuntimeError, "Invalid from_time_zone argument #{invalid_from_time_zone} See ActiveSupport::TimeZone")
      end
    end
  end
end
