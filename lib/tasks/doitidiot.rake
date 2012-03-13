namespace :doitidiot do

  desc "Make the todos angry and re-order"
  task :get_angry => :environment do
    # make todos angry
    puts "making todos angry"
    (1..5).each do |level|
      todos = Todo.alive.where(:created_at.gt => level.week.ago.strftime("%Y-%m-%d"), :created_at.lt => level.week.ago.strftime("%Y-%m-%d 23:59:59"))
      todos.each do |todo|
        todo.anger_level  = level + 1
        todo.save
      end
    end

    # go through users and bump up angry todos
    puts "re-ordering todos"
    User.all.each do |user|
      todo_count  = user.todos.count
      base_bump   = 20
      # start with newest, least angry todos so oldest and angriest go last
      todos       = user.todos.alive
      todos_array = todos.map{|t| {:id => t.id, :ordinal => t.ordinal, :created_at => t.created_at, :anger_level => t.anger_level}}
      todos_array.each_with_index do |todo, index|
        next if todo[:anger_level] == 1
        percent_bump  =  ((todo[:anger_level] - 1) * base_bump) / 100.00
        todo_bump     = todo_count * percent_bump 
        # find new ordinal
        new_ordinal                   = todo[:ordinal] - todo_bump.round < 1 ? 1 : todo[:ordinal] - todo_bump.round
        todos_array[index][:ordinal]  = new_ordinal
      end
      # sort order: ordinal, created_at, anger_level
      todos_array.sort! do |a,b|
        if a[:ordinal] == b[:ordinal]
          b[:anger_level] <=> a[:anger_level]
        else
          a[:ordinal] <=> b[:ordinal]
        end
      end
      # now update todos
      todos_array.each_with_index do |todo, index|
        Todo.find(todo[:id]).update_attributes(:ordinal => index + 1)
      end

    end
  end
  
  # run every hour - sends once a day for each user
  desc "Send out daily to do emails"
  task :daily_emails => :environment do

    # go through users and send emails at the 
    User.all.each do |user|
      Time.zone = user.time_zone
      if Time.zone.now.hour == user.time_to_send_to_i
        if user.provider == 'twitter' && user.todos.alive.count > 0
          # tweet for this user of they have any todos left
          insult          = Redact.where(:code_name => 'diswnouns').first.redact_array.first
          twitter_client  = Twitter::Client.new(:oauth_token => user.token, :oauth_token_secret => user.secret)
          twitter_client.update("Still got stuff to do at http://doitidiot.com. I'm a total #{insult}")
        else
          puts "Mailing #{user.email}"
          TodoMailer.daily_todos(user).deliver
        end
      else
        #puts "Try again next hour for #{user.email}"
      end
    end
  end
  
  # run every day - tweet a daily insult
  desc "Send out daily insult on twitter"
  task :daily_insult => :environment do

    insult          = Redact.where(:code_name => 'diswnouns').first.redact_array.first
    twitter_client  = Twitter::Client.new
    twitter_client.update("Your daily insult from doitidiot.com: #{insult}")

  end
  
end
