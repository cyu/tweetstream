module TweetStream
  # Provides simple access to the Twitter Streaming API (http://apiwiki.twitter.com/Streaming-API-Documentation)
  # for Ruby scripts that need to create a long connection to
  # Twitter for tracking and other purposes.
  #
  # Basic usage of the library is to call one of the provided
  # methods and provide a block that will perform actions on
  # a yielded TweetStream::Status. For example:
  #
  #     TweetStream::Client.new('user','pass').track('fail') do |status|
  #       puts "[#{status.user.screen_name}] #{status.text}"
  #     end
  #
  # For information about a daemonized TweetStream client,
  # view the TweetStream::Daemon class.
  class Client < Connection

    # Create a new client with the Twitter credentials
    # of the account you want to be using its API quota.
    # You may also set the JSON parsing library as specified
    # in the #parser= setter.
    def initialize(consumer_key, consumer_secret, access_key, access_secret, parser = :json_gem)
      super
    end
   
    # Returns all public statuses. The Firehose is not a generally
    # available resource. Few applications require this level of access. 
    # Creative use of a combination of other resources and various access 
    # levels can satisfy nearly every application use case. 
    def firehose(query_parameters = {}, &block)
      EventMachine::run { super }
    end
    
    # Returns all retweets. The retweet stream is not a generally available 
    # resource. Few applications require this level of access. Creative
    # use of a combination of other resources and various access levels
    # can satisfy nearly every application use case. As of 9/11/2009,
    # the site-wide retweet feature has not yet launched,
    # so there are currently few, if any, retweets on this stream.
    def retweet(query_parameters = {}, &block)
      EventMachine::run { super }
    end
    
    # Returns a random sample of all public statuses. The default access level 
    # provides a small proportion of the Firehose. The "Gardenhose" access
    # level provides a proportion more suitable for data mining and
    # research applications that desire a larger proportion to be statistically
    # significant sample.
    def sample(query_parameters = {}, &block)
      EventMachine::run { super }
    end

    # Make a call to the statuses/filter method of the Streaming API,
    # you may provide <tt>:follow</tt>, <tt>:track</tt> or both as options
    # to follow the tweets of specified users or track keywords. This
    # method is provided separately for cases when it would conserve the
    # number of HTTP connections to combine track and follow.
    def filter(query_params = {}, &block)
      EventMachine::run { super }
    end
    
    def site_follow(*user_ids, &block)
      EventMachine::run { super }
    end
    
    # Set a Proc to be run when a deletion notice is received
    # from the Twitter stream. For example:
    #
    #     @client = TweetStream::Client.new('user','pass')
    #     @client.on_delete do |status_id, user_id|
    #       Tweet.delete(status_id)
    #     end
    #
    # Block must take two arguments: the status id and the user id.
    # If no block is given, it will return the currently set 
    # deletion proc. When a block is given, the TweetStream::Client
    # object is returned to allow for chaining.
    def on_delete(&block)
      if block_given?
        @on_delete = block
        self
      else
        @on_delete
      end
    end
    
    # Set a Proc to be run when a rate limit notice is received
    # from the Twitter stream. For example:
    #
    #     @client = TweetStream::Client.new('user','pass')
    #     @client.on_limit do |discarded_count|
    #       # Make note of discarded count
    #     end
    #
    # Block must take one argument: the number of discarded tweets.
    # If no block is given, it will return the currently set 
    # limit proc. When a block is given, the TweetStream::Client
    # object is returned to allow for chaining.
    def on_limit(&block)
      if block_given?
        @on_limit = block
        self
      else
        @on_limit
      end
    end
    
    # Set a Proc to be run when an HTTP error is encountered in the
    # processing of the stream. Note that TweetStream will automatically
    # try to reconnect, this is for reference only. Don't panic!
    #
    #     @client = TweetStream::Client.new('user','pass')
    #     @client.on_error do |message|
    #       # Make note of error message
    #     end
    #
    # Block must take one argument: the error message.
    # If no block is given, it will return the currently set 
    # error proc. When a block is given, the TweetStream::Client
    # object is returned to allow for chaining.
    def on_error(&block)
      if block_given?
        @on_error = block
        self
      else
        @on_error
      end
    end

    # Set a Proc to be run when connection established.
    # Called in EventMachine::Connection#post_init
    #
    #     @client = TweetStream::Client.new('user','pass')
    #     @client.on_inited do
    #       puts 'Connected...'
    #     end
    #
    def on_inited(&block)
      if block_given?
        @on_inited = block
        self
      else
        @on_inited
      end
    end
    
    def start(path, query_parameters = {}, &block) #:nodoc:
      EventMachine::run { connect(path, query_parameters, &block) }
    end
    
    # Terminate the currently running TweetStream.
    def stop
      EventMachine.stop_event_loop
      @last_status
    end
 
  end
end
