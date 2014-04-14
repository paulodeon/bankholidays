module BankHolidays

  # Get a list of all bank holidays
  def self.all
    self.get_dates
  end

  # Get the next bank holiday
  def self.next
    self.get_dates.reject { |x| x[:date] < Date.today }.first
  end

  private

    def self.get_dates
      res = HTTParty.get "https://www.gov.uk/bank-holidays/england-and-wales.ics"
      ics = Icalendar.parse( res )
      cal = ics.first

      [].tap do |dates|
        cal.events.each do |e|
          dates << { :date => e.dtstart, :name => e.summary }
        end
      end
    end

end
