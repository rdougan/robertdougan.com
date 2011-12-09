# http://samsoff.es/posts/my-deploy-script
desc 'Deploy to Heroku and push to GitHub'
task :deploy do
  unless `git status -s`.length == 0
    puts 'WARNING: There are uncommitted changes'
    puts 'Commit any changes before deploying.'
    exit
  end

  `git push origin master`
  `git push heroku master`
end