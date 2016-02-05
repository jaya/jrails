module Jrails::ConditionalGet
    def stale?(options = {})
        last_modified = options.delete(:last_modified)
        return true unless request.headers['HTTP_IF_MODIFIED_SINCE']

        stale = Time.parse(request.headers['HTTP_IF_MODIFIED_SINCE']) < last_modified
        head :not_modified unless stale
        stale
    end
end