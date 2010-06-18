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