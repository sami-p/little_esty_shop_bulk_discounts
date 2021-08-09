class ApplicationController < ActionController::Base

end

private

def upcoming_holidays
  json = NagerService.new.holidays
  Holiday.new(json)
end
