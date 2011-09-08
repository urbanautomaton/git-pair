Feature: Resetting the current authors
  In order to revert to original settings
  A user should be able to
  reset the current pair

  Scenario: resetting the current authors
    Given I have added the author "Linus Torvalds <linus@example.org>"
    And my global Git configuration is setup with user "Global User"
    And I switch to the pair "LT"
    When I reset the current authors
    Then `git pair` should display "Global User" for the current author
