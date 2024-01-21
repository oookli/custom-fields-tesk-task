# Test task for Senior Ruby on Rails Engineer

This README provides an overview of the project and instructions on how to set it up and use it.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)

## Introduction

This is a Ruby on Rails test task to evaluate my proficiency in building Rails applications.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- **Ruby:** You will need Ruby (version 3.3.0) installed on your system. You can check your Ruby version by running:
    `ruby -v`
To install or upgrade Ruby, refer to the official Ruby installation guide: [Ruby Installation Guide](https://www.ruby-lang.org/en/documentation/installation/).
- **Ruby on Rails:** This project is built with Ruby on Rails (version 7.1.3). You can check your Rails version by running:
    `rails -v`
If you need to install or upgrade Rails, you can do so using the following command: `gem install rails -v 7.1.3`.
- **Database:** The application uses PostgreSQL (version 13.12) as the database management system. Make sure PostgreSQL is installed and running on your system. You can download PostgreSQL from the official website: [PostgreSQL Downloads](https://www.postgresql.org/download/).

## Installation

To set up this Rails application on your local development environment, follow these steps:

- Clone this repository to your local machine:
   ```shell
   git clone https://github.com/yourusername/your-rails-app.git
- Change into the project directory:
   ```shell
   cd your-rails-app
- Install gem dependencies:
   ```shell
   bundle install
- Create the database:
   ```shell
   rails db:create
- Run database migrations:
   ```shell
   rails db:migrate
- Start the Rails server:
   ```shell
   rails s
- Access the application in your web browser at `http://localhost:3000`.

## Usage

### API Endpoints

#### `/users` Endpoint (CRUD Operations)

##### Create a New User
- **POST** `/users`
  - To create a new user, send a POST request to this endpoint.
  - Include the following parameters in the request body:
    - `email` (required): The email address of the user.
    - custom fields specified on GET /user_custom_fields with such format
    ```shell
        internal_name: value
    ```

##### Retrieve User Information
- **GET** `/users/:id`
  - Retrieve information about a specific user by replacing `:id` with the user's unique identifier.

##### Update User Information
- **PUT** `/users/:id`
  - Update the information of a specific user by sending a PUT request to this endpoint.
  - Include the parameters you want to update in the request body.

##### Delete a User
- **DELETE** `/users/:id`
  - Delete a user by sending a DELETE request to this endpoint, replacing `:id` with the user's unique identifier.

#### `/user_custom_fields` Endpoint (CRUD Operations)

##### Create a Custom Field
- **POST** `/user_custom_fields`
  - To create a new custom field for users, send a POST request to this endpoint.
  - Include the following parameters in the request body:
    - `name` (required): The name or label of the custom field.
    - `field_type` (required): The type of the custom field, which can be one of the following: `text`, `number`, `dropdown`, or `multi_dropdown`.
    - `options` (optional): List of options that have to be chosen when field_type
        is `dropdown` or `multi_dropdown`

##### Retrieve Custom Fields
- **GET** `/user_custom_fields`
  - Retrieve a list of all custom fields available that uses for users.

##### Update a Custom Field
- **PUT** `/user_custom_fields/:id`
  - Update the information of a specific custom field by sending a PUT request to this endpoint.
  - Include the parameters you want to update in the request body, replacing `:id` with the custom field's unique identifier.

##### Delete a Custom Field
- **DELETE** `/user_custom_fields/:id`
  - Delete a custom field by sending a DELETE request to this endpoint, replacing `:id` with the custom field's unique identifier.

### Example Usage

Here's an basic examples how to interact with the API:

- create a new user custom field using the `/user_custom_fields` endpoint:

    ```shell
    curl -X POST \
         -H "Content-Type: application/json" \
         -d '{
            "name": "gender",
            "field_name": "dropdown",
            "options": ["male", "female", "other"]
         }' \
         "http://localhost:3000/user_custom_fields"
    ```

- create a new user with custom fields using the `/users` endpoint:

    ```shell
    curl -X POST \
         -H "Content-Type: application/json" \
         -d '{
            "email": "some@test.com",
            "gender": "female"
         }' \
         "http://localhost:3000/users"
    ```
