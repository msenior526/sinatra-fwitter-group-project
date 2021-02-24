class TweetsController < ApplicationController

    get '/tweets' do
        if logged_in?
            @tweets = Tweet.all
            # binding.pry
            erb :'tweets/tweets'
          else
            redirect '/login'
          end
    end

    get '/tweets/new' do
      if logged_in?
        erb :'tweets/new'
      else 
        redirect '/login'
      end
    end

    post '/tweets' do
      if logged_in?
        if params[:content] == ""
          redirect "/tweets/new"
        else
          @tweet = current_user.tweets.build(content: params[:content])
          if @tweet.save
            redirect "/tweets/#{@tweet.id}"
          else
            redirect "/tweets/new"
          end
        end
      else
        redirect '/login'
      end
    end

    get '/tweets/:id' do
      if logged_in?
        @tweet = Tweet.find_by_id(params[:id])
        erb :'tweets/show_tweet'
      else
        redirect '/login'
      end
    end
    
    get '/tweets/:id/edit' do
      if logged_in?
        @tweet = Tweet.find_by_id(params[:id])
        erb :'tweets/edit_tweet'
      else
        redirect '/login'
      end
    end

    patch '/tweets/:id' do
      if logged_in?
        if params[:content] == ""
          redirect to "/tweets/#{params[:id]}/edit"
        else
          @tweet = Tweet.find_by_id(params[:id])
          if @tweet && @tweet.user == current_user
            if @tweet.update(content: params[:content])
              redirect to "/tweets/#{@tweet.id}"
            else
              redirect to "/tweets/#{@tweet.id}/edit"
            end
          else
            redirect to '/tweets'
          end
        end
      else
        redirect to '/login'
      end
    end

    delete '/tweets/:id' do
      if logged_in?
        tweet = Tweet.find_by_id(params[:id])
        if tweet.user != current_user
          redirect "/tweets"
        else
          tweet.delete
        end
      else 
        redirect "/login"
      end
    end
end
