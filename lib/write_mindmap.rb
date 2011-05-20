$LOAD_PATH <<File.expand_path('../../../lib',__FILE__)
require 'rest-client'
require 'nokogiri'
require 'hpricot'



class MindMap
	attr_accessor :dataConnection
	attr_accessor :localizer
	
	def initialize(url_with_protocol, username = 'admin', password = 'admin')
		base_url = url_with_protocol[7..url_with_protocol.length]
		@api_url       = base_url + 'rest-1.v1/Data'
		@localizer_url = base_url + 'loc.v1'
		@config_url = base_url + "config.v1"
		@meta_url = base_url + 'meta.v1'
		@dataConnection = RestClient::Resource.new(@api_url, username, password)
		@localizer = RestClient::Resource.new(@localizer_url)
		@metaConnection = RestClient::Resource.new(@meta_url)
	end
	
	def data
		@dataConnection
	end
	
	# add_relationship is used to add a new element to a multi-value relationship
	def plans(scope)
		url="RegressionPlan?sel=Name&where=RegressionPlan.Scope='#{scope}'"
		plan_ids = Nokogiri::XML(@dataConnection[url].get.to_s)
	end
	
	def plan_name(plan_id)
		id = plan_id.sub("RegressionPlan:","")
		url="RegressionPlan/#{id}?sel=Name"
		Nokogiri::XML(@dataConnection[url].get.to_s)
	end

	def scope_name(scope_id)
		id = scope_id.sub("Scope:","")
		url="Scope/#{id}?sel=Name"
		Nokogiri::XML(@dataConnection[url].get.to_s)
	end
	
	def suites(plan_id)
		url="RegressionSuite?sel=Name&where=RegressionPlan='#{plan_id}'"
		Nokogiri::XML(@dataConnection[url].get.to_s)
	end

	def tests(suite_id)
		url="RegressionTest?sel=Name&where=RegressionSuites='#{suite_id}'"
		Nokogiri::XML(@dataConnection[url].get.to_s)
	end	

	def write_mindmap(oid)
		if oid.include? 'Plan' then write_plan_data(oid) end
		if oid.include? 'Scope' then write_scope_data(oid) end
	end
	
	def write_scope_data(scope)
		f = File.open("scope_mindmap.txt","w")
		scope_name = scope_name(scope)
		f.puts scope_name.elements[0].content
		plan_ids = plans(scope).elements[0].element_children
		plan_ids.each do |plan_id|
			puts plan_id.content
			f.puts plan_id.content
			suite_ids = suites(plan_id.attribute('id').value).elements[0].element_children
			suite_ids.each do |suite_id|
				f.puts "   " + suite_id.elements[0].content
				test_names = tests(suite_id.attribute('id').value).elements[0].element_children
				test_names.each do |test|
					f.puts "      " + test.content
				end
			end
		end
		f.close
	end
	
	
	def write_plan_data(plan)
		f = File.open("plan_mindmap.txt","w")
		plan_name = plan_name(plan)
		f.puts plan_name.elements[0].content
		suite_ids = suites(plan).elements[0].element_children
		suite_ids.each do |suite_id|
			f.puts "   " + suite_id.elements[0].content
			test_names = tests(suite_id.attribute('id').value).elements[0].element_children
			test_names.each do |test|
				f.puts "      " + test.content
			end
		end
		f.close
	end
		
		

		
end 

	