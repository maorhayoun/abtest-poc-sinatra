require 'sinatra/base'
require 'json'

class MyApp < Sinatra::Base

	get '/feature/:feat/:uid' do
		content_type :json
		
		# hash feature key
		key = h("#{params[:feat]}#{params[:uid]}", 100)
		puts key

		# get the feature variants
		f = params[:feat].to_s
		parsed = JSON.parse(getFeatures()) 
		vars = parsed[f]["variants"]

		# select the best matched variant
		vars.each do |item| 
		  if (item["perc"]*100 > key)
		  	return  item["value"].to_json
		  end
		end
         
        "not found"       
	end

	helpers do
		def getFeatures()
			{ :intro_text => { 
				:variants => [
					{
						:perc => 0.5,
						:value => { :text => 'welcome to my amazing website :))' }
					},
					{
						:perc => 1,
						:value => { :text => 'welcome to my crazy site!@!@!@!@' }
					}
				]}
			}.to_json
		end 

		def h(x, m) 
			   l =	x.split("").map { |s| s.ord }.inject(:+)
			   return l % m
		end	 

	end

	run! if app_file == $0	
end
