require 'factory_bot'
FactoryBot .define do
	factory :movie do
		title {'do not care'}
		rating {'PG'}
		director {nil}
		release_date {10.years.ago}
	end
end	
