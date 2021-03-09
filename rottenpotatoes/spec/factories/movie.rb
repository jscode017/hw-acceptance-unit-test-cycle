require 'factory_bot'
FactoryBot .define do
	factory :movie do
		title {'do not care'}
		rating {'PG'}
		director {nil}
	end
end	
