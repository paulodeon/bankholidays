# frozen_string_literal: true
module BankHolidays
  class << self
    # Get a list of all bank holidays
    def all
      bank_holidays_per_year
    end

    # Get the next bank holiday
    def next
      bank_holidays_per_year.reject { |x| x[:date] < Date.today }.first
    end

    private

    def bank_holidays_per_year
      res = HTTParty.get 'https://www.gov.uk/bank-holidays/england-and-wales.ics'
      ics = Icalendar::Calendar.parse(res)
      cal = ics.first

      [].tap do |dates|
        cal.events.each do |e|
          dates << { date: e.dtstart, name: e.summary }
        end
      end
    end
  end
end