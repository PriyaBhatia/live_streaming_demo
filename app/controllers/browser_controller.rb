require 'reloader/sse'

class BrowserController < ApplicationController
  include ActionController::Live

  def index
    # SSE expects the `text/event-stream` content type
    response.headers['Content-Type'] = 'text/event-stream'

    sse = Reloader::SSE.new(response.stream)

    notifier = INotify::Notifier.new
    notifier.watch("app/views/users/index.html.erb", :modify){
      sse.write({ :dirs => "test" }, :event => 'refresh')
    }

    notifier.run
    notifier.process
  end
end
