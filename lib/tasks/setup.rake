namespace :db do
  task :seed_fake => :environment do
    if defined?(Product.solr_search)
      begin
        Rake::Task["sunspot:solr:start"].invoke
      rescue Exception => e
        puts e
      end
    end
    file_to_load        = Rails.root + "db/seed/config_admin.yml"
    config_information  = YAML::load( File.open( file_to_load ) )
    unless Brand.first
      config_information.each do |table|
        #puts table[0].singularize.camelcase
        tables_model = table[0].singularize.camelcase.constantize
        table[1].each_pair do |num, attribute_hash|
          puts [num, tables_model.to_s].join(' | ')
          tables_model.create( attribute_hash['attributes'])
        end
      end
    else
      puts 'IT APPEAR YOU ALREADY HAVE DATA. PLEASE truncate your DB or take a look because it might be ready to go!!'
    end
  end
end