# Responsibilities
#
# - Maintain state common to all Helper classes.

class Helper
  def initialize(args={})
    args.should be_kind_of(Hash)

    @session = nil
    if args[:session] then
      @session = args[:session]
      @session.should be_kind_of(Capybara::Session)
    end
  end

  def on_home_page?
    false
  end
end

