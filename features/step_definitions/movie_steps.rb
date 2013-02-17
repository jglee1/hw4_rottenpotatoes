# Add a declarative step here for populating the DB with movies.

ActiveRecord::Schema.define do
  drop_table :movies if :movies
  create_table :movies do |table|
    table.column :title, :string
    table.column :rating, :string
    table.column :release_date, :date
  end
end
class Movie < ActiveRecord::Base

end


Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create movie
  end
end

# Make sure that one string (regexp) occurs before or after another one
# on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  assert page.body =~ /#{e1}.*#{e2}/m, "#{e1} was not before #{e2}"
end

# Make it easier to express checking or unchecking several boxes at once
# "When I uncheck the following ratings: PG, G, R"
# "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(',').each do |rating|
    if uncheck
      uncheck "ratings_#{rating}"
    else
      check "ratings_#{rating}"
    end
  end
end

Then /I should see all of the movies/ do

  assert(all("table#movies tr").count == Movie.all.count + 1)

#  movies = Movie.all

#  if movies.size == 10
#    movies.each do |movie|
#      assert page.body =~ /#{movie.title}/m, "#{movie.title} did not appear"
#    end
#  else
#    false
#  end
end

Then /I should not see any movies/ do
  movies = Movie.all
  movies.each do |movie|
    assert true unless page.body =~ /#{movie.title}/m
  end
end

Then /^the director of "(.*?)" should be "(.*?)"$/ do |movie_title, new_director|
  movie = Movie.find_by_title movie_title
  movie.director.should == new_director
end

Given /I check the movies with ratings 'PG' or 'R' only/ do
  check('ratings_PG')
  check('ratings_R')
  uncheck('ratings_PG-13')
  uncheck('ratings_G')
  uncheck('ratings_NC-17')
end

Given /I uncheck on all ratings/ do
  uncheck('ratings_PG')
  uncheck('ratings_R')
  uncheck('ratings_PG-13')
  uncheck('ratings_G')
  uncheck('ratings_NC-17')
end

Given /I check on all ratings/ do
  check('ratings_PG')
  check('ratings_R')
  check('ratings_PG-13')
  check('ratings_G')
  check('ratings_NC-17')
end


When /I click on 'submit'/ do
  click_button('ratings_submit')
end


Then /I should see only 'PG' or 'R' rated movies/ do
  page.body.should match(/<td>PG<\/td>/)
  page.body.should match(/<td>R<\/td>/)
end

Then /I should not see moves with ratings other than 'PG' or 'R'/ do
  page.body.should_not match(/<td>PG-13<\/td>/)
  page.body.should_not match(/<td>G<\/td>/)
end

#Then /I should see an empty table/ do
# assert(all("table#movies tr").count == 0)
# page.body.scan(/<tr>/).length.should == 0
#end




When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and reuse the "When I check..." or
  # "When I uncheck..." steps in lines 89-95 of web_steps.rb

  rating_list.split(',').each do |r|
    rating = "ratings_" + r
    uncheck == true ? uncheck(rating) : check(rating)
  end
end


