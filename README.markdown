# Story Driven Development in Ruby on Rails

## Project Goal

This project is actually a tutorial with step by step guides how to conduct Story Driven Development in Ruby on Rails.

## The Story

My company has a fortnight budget allocated for buying pantry food. When it's my team's turn to buy food for the pantry next week, it would be convenient if everyone who has an opinion on what should be bought, would just use this project to suggest, on the condition that the suggestion does not exceed the budget.

This initial take is simplistic and does not yet take into an account of fairness. For example, if the budget is $100 and someone suggests buying Wagyu beef steaks worth $90, the remaining budget left would be $10.

The main project goal is to use this feature request that holds close to your hearts to better appreciate what Story Driven Development can do for you.

Feel free to fork this project and write more cucumber stories and code to pass the tests.

Let's make this a good example to introduce folks to story driven development!

Cheers,
Alvin Lai

## Tool stack:

* **cucumber**: Acceptance testing
* **webrat**: View testing
* Standard Rails scaffolding
* **shoulda**: Add on to Ruby's Test::Unit
* **factory_girl**: manageable test fixtures
  
## Important:

* Test your own code
* Don't write tests for existing Rails generated code, since they're usually already pretty thoroughly tested
  
## Outside in development:

* Start from the highest level at 10,000 feet
* Then drill down to the core details:
  * Tell the story with cucumber, what to expect every step of the way
  * Write functional tests for controller
  * Write unit tests for models
* Tests fail
* Generate scaffolds
* Write more custom code to pass tests
* Rinse and repeat
  
## Cucumber thought process:

* Ask why:
  * Why would I want to do this
  * As a stakeholder, who specifically?
  * What do I want to do exactly
* Specify the flow and steps
  
## Demo commands:

Create a new 2.2.2 Rails versioned app:

    $ rails _2.2.2_ pantry

Add in `environment.rb`

    config.gem 'factory_girl', :version => '1.2.4'
    config.gem 'thoughtbot-shoulda', :lib => "shoulda", :source => "http://gems.github.com"

Install cucumber and ZenTest's autotest gem

    $ gem install cucumber
    $ gem install ZenTest

Generate cucumber files

    $ script/generate cucumber
    
Modify `config/cucumber.yml` and add to default:

    --color
    
Then run autotest:

    $ AUTOFEATURE=true autotest
    
Create file: `app/features/suggest_favorite_food.feature`

    Feature: Suggest favorite food
      In order to enjoy the food in my office's pantry
      As a worker bee
      I want to suggest my favorite food to be bought fortnightly

      Scenario Outline: Suggest food for budget
        Given I have a budget with "<budget_left>" dollars left 
        And I am on the list of budgets
        And I follow "<budget_left>"
        And I should see "Suggest food"
        When I fill in "name" with "<food_name>"
        And I fill in "cost" with "<food_cost>"
        And I press "Suggest"
        Then I should see "<new_budget_left>"
        And I should see "<food_submission_outcome>"

      Examples:
        | budget_left | food_name         | food_cost | food_submission_outcome | resulting_page  | new_budget_left |
        | 10          | nescafe gold      | 8         | food accepted           | food_accepted   | 2               |
        | 1           | wagyu beef steak  | 50        | food exceeded budget    | suggest_food    | 1               |

Create `features/step_definitions/submit_favorite_food.rb` step definition and modify them

    Given /^I have a budget with "([^\"]*)" dollars left$/ do |dollars|
      Factory.create(:budget, :original_amount => dollars.to_i)
    end

Create the `/factory` folder for factory_girl

    mkdir test/factories
    
Create `test/factories/budget.rb` Factory

    Factory.define :budget do |b|
      b.name 'Happy'
      b.original_amount 40
    end

Budget scaffold

    $ script/generate scaffold budget name:string original_amount:integer
    
Migrate databases and prepare for test

    $ rake db:migrate
    $ rake db:test:prepare

Add to `features/support/paths.rb`

    when /list of budgets/
      '/budgets'

Modify `app/views/budgets/index.html`

    link_to to budget.original_amount

Modify `app/views/budgets/show.html`

    <p>Suggest food</p>
    
Food scaffold

    $ script/generate scaffold food name:string cost:integer budget_id:integer
    
Migrate databases and prepare for test again

    $ rake db:migrate
    $ rake db:test:prepare
    
Extract Food's form fields into `_form.html.erb` partial to reuse them

    <%= f.error_messages %>
    <p>
      <%= f.label :name %><br />
      <%= f.text_field :name %>
    </p>
    <p>
      <%= f.label :cost %><br />
      <%= f.text_field :cost %>
    </p>
    <p>
      <%= f.label :budget_id %><br />
      <%= f.text_field :budget_id %>
    </p>

  
Set render partial for `new.html.erb`

    <%= render :partial => 'form', :locals => {:f => f} %>

Add suggest Food form partial into budget's `show.html.erb`

    <% form_for(@food) do |f| %>
      <%= render :partial => 'foods/form', :locals => {:f => f} %>
      <p>
        <%= f.submit "Suggest" %>
      </p>
    <% end %>

  
Add to `FoodController#create`, `if @food.save`

    @format.html { redirect_to(@food.budget) }
  
Add to `BudgetController#show`

    <p><b>Original amount:</b><%=h @budget.original_amount %></p>
  
    @food = Food.new(:budget => @budget)

Add Food model association
  
    belongs_to :budget
    
Add Budget model association
  
    has_many :foods
    
Change `BudgetController#create` method

    flash[:notice] = 'food accepted'
  
Write unit tests for food to disallow suggestion when there's not enough budget left:

    context "A Food instance" do
      setup do
        @budget = Factory(:budget, :original_amount => 20)
        @food = Factory.build(:food, :cost => 30, :budget => @budget)
      end
    
      should "not be allowed when its cost exceeds it's budget" do
        @food.save
        assert @food.new_record? # not saved
      end
    end

  
Write unit tests for Budget to show amount left

    context "A Budget instance" do
      setup do
        @budget = Factory(:budget, :original_amount => 30)
      end
    
      should "return it's amount left" do
        @food = Factory(:food, :cost => 20, :budget => @budget)

        assert 10, @budget.amount_left
      end
    end

Create food Factory

    Factory.define :food do |f|
      f.name 'Abalone'
      f.cost 100
    end


Write methods for Budget to pass test

    def amount_left
      used_up = 0
      self.foods.collect{|f| f.cost}.each{|c| used_up += c}
    
      original_amount - used_up
    end

  
Add validation to Food


    validate :must_not_exceed_budget
  
    def must_not_exceed_budget
      self.errors.add_to_base("food exceeded budget") unless self.budget.amount_left >= self.cost
    end
