# HOTEL SEARCH

## ANALYSIS

API server calls other application's API in order to get some data, in this problem is hotels. The call is made often, the data in response may be huge, and in reality it is not good for any application to wait for such a long time to get the response

In case of the response is not going to change often in the external application. We can cache the response in memory store such as Redis with an expiration time so instead of the actual call, users could get the response from the Redis cache.

From the requirement, the expiration time of the data is 5 minutes. When the data expires, the call goes to the external server and refresh the data in cache. Therefore, next time the data will be returned from the cache

In conclusion, when users search for cheapest hotels, the API server needs to fetch the results either from the cache or directly from the suppliers

![Diagram](https://i.imgur.com/bAMUtjz.png)

## DESIGN

[1] The system is designed with:
- `Supplier` model represents for an provider of the hotels. It stores supplier name and URL to example data.
- `SearchController` is API controller for endpoint `api/v1/suppliers/search`
- `Suppliers::SearchService` service is used to fetch data either from cache or from external application.

[2] Unit tests are also implemented
- Run all specs: `rspec`
- Run specific spec: `rspec spec/**/*_spec.rb`

## INSTRUCTION

### Dependencies
1. Ruby 2.5.1
2. Rails 5.2.4.1
3. Bundler 1.17.3

### How to run locally, in terminal
1. Clone the repository:
  ```sh
    git clone git@github.com:lanhhoang/hotel-search.git
  ```
2. Install ruby 2.5.1 using `rvm` or `rbenv`
  ```sh
    rvm install ruby-2.5.1 && rvm use ruby-2.5.1

    rbenv install 2.5.1
  ```
3. Install all your gems using bundler
  ```sh
    bundle install
  ```
4. Create database, run migrations and populate database with seed
  ```sh
    rails db:create db:migrate db:seed
  ```
5. Run local server
  ```sh
    rails server
  ```

### Using Postman to test API
- We will use the following URL
```
http://localhost:3000/api/v1/suppliers/search?checkin=20191201&checkout=20191231&destination=Singapore&guests=1&suppliers=
```

1. Set your HTTP request to GET.
2. In the request URL field, input above link, change input of  `suppliers` param
3. Click Send
4. You will see 200 OK Message
5. There should be results in the body which indicates that API has run successfully.

![Postman](https://i.imgur.com/JBh7VRD.png)
