# Responsibilities
# - Visit URL
# - Detect and handle redirects
# - Proxy undefined methods to the appropriate helper class
# - Return current session URL

require 'lib/path_to_helper_mapper'

class PageObject
  attr_reader :session

  def initialize(args)
    @session = nil
    @helper = nil
    @pthm = PathToHelperMapper.new(args)

    if args[:session] then
      @session = args[:session]
      @session.should be_kind_of(Capybara::Session)
    end

    self
  end

  def visit(url)
    url.should be_kind_of(String)
    url.size.should > 0

    @session.visit(url)
    choose_helper
    self
  end

  def current_url_without_query_parameters
    @session.current_url.split(/\?/).first
  end

  def method_missing(msg, *args, &blk)
    results = @helper.send(msg, *args, &blk)
    choose_helper
    return results
  end

  def have_content?(text)
    @session.have_content?(text)
  end

  private

  def choose_helper
    @helper = @pthm.helper_for_path(@session.current_path)
  end
end


# Convenience class
class HomePage < PageObject
  def initialize
    super(:session => page, :map_filename => "url-mappings.yaml").visit($home_page)
  end
end

