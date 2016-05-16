Feature: Provision and Install

  Background:
    Given I have a running server
    And I provision it

  Scenario: Install elasticsearch
    When I install elasticsearch
    Then it should be successful
    And elasticsearch should be running
    And it should be accepting connections on port 9200

  Scenario: Install logstash
    When I install logstash
    Then it should be successful
    And logstash etc directory should be present
    And logstash should be running

  Scenario: Install kibana
    When I install kibana
    Then it should be successful
    And kibana should be running
    And it should be accepting connections on port 5601

  Scenario: Install nginx
    When I install nginx
    Then it should be successful
    And nginx should be running
    And I create ssl certificate
    And I create stark-wildwood folder

  Scenario: Install apache2-utils
    When I install apache2-utils
    Then it should be successful
  
  Scenario: Install python passlib
    When I install python-passlib
    Then it should be successful

  Scenario: Create kibana.htpassword
    When I create kibana.htpassword
    Then kibana.htpassword file should exist

  Scenario: Create kibana-write.htpassword
    When I create kibana-write.htpassword
    Then kibana-write.htpassword file should exist
