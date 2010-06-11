require 'sequel'

database = ARGV[0]
table = ARGV[1]

DB = Sequel.connect(database)

class Maker
   include Sequel::Inflections
   def self.pluralize_(some)
      #singularize(some)
      pluralize(some)
   end
   def self.singularize_(some)
      singularize(some)
   end
   
   def initialize(database, table_name)
      @database = database
      @table_name = table_name
      @view_directory = "./viewstest"
   end
   
   def dump_schema
      puts "table: signle=#{singularize(@table_name)}, plunder=#{@table_name}"
      schemas = @database.schema(@table_name)
      schemas.each do |s|
         p s[0]
         p s[0].to_s
         p s[1]
      end
   end
   
   def generate_view
      puts "generate #{@table_name} view."
      single_name = singularize(@table_name)
      # new
      File.open("#{@view_directory}/new_#{single_name}.erb", "w+") do |f|
         f.puts <<-"EOS"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title>New #{single_name}</title>
</head>
<body>
	<h1>New #{single_name}</h1>
	<form method="post" action="/#{single_name}/new">
		<dl>
         EOS
         schemas = @database.schema(@table_name)
         schemas.each do |s|
            f.puts "			<dt>#{s[0]} <input type=\"text\" name=\"#{s[0]}\"></dt>"
         end
         f.puts <<-"EOS"
			<dt><input type="submit" value="create"></dt>
		</dl>
	</form>
	<a href="/">back</a>
</body>
</html>
         EOS
      end
      
      # edit
      File.open("#{@view_directory}/edit_#{single_name}.erb", "w+") do |f|
         f.puts <<-"EOS"

         EOS
      end
      
      # list
      File.open("#{@view_directory}/#{@table_name}.erb", "w+") do |f|
         f.puts <<-"EOS"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
         <title>#{@table_name}</title>
</head>
<body>
         <h1>#{@table_name}</h1>
	<table cellspacing="0">
		<th>
            EOS
            schemas = @database.schema(@table_name)
            schemas.each do |col|
            f.puts "			<td>#{col[0]}</td>"
            end

            f.puts <<-"EOS"
		</th>
	<% records.each do |r| %>
            <tr>
            EOS
            schemas = @database.schema(@table_name)
            schemas.each do |col|
               f.puts "			<td><%= r[:#{col[0]}] %></td>"
            end

            f.puts <<-"EOS"
            <td><a href="/#{single_name}/<%= r[:id] %>/edit">edit</a></td>
            <td><a href="/#{single_name}/<%= r[:id] %>/delete">delete</a></td>
		</tr>
	<% end %>
	</table>
         <p><a href="/#{single_name}/new">new</a></p>
	</div>
</body>
</html>
         EOS
      end
      
      def sample
         puts "add following codes to main.rb."
         single_name = singularize(@table_name)
         schemas = @database.schema(@table_name)
         
         #list
         puts "#---------------------"
         puts <<-"EOS"
         get '/#{@table_name}' do
            erb :users, :locals => {
               :records => DB[:#{@table_name}]
            }
         end
         EOS
         
         #new get
         puts "#---------------------"
         puts <<-"EOS"
         get '/#{single_name}/new' do
            erb :new_#{single_name}
         end
         EOS
         
         puts "#---------------------"
         puts <<-"EOS"
         post '/#{single_name}/new' do
            DB[:#{@table_name}].insert({
            EOS
            
            schemas.each do |col|
               puts "               :#{col[0]} => params[:#{col[0]}],"
            end
            puts <<-"EOS"
            })
         redirect '/#{@table_name}'
         end
         EOS
         
      end
   end
end

m = Maker.new(DB, table)
m.dump_schema
m.generate_view
m.sample