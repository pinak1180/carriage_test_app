**Details About the Endpoints: **

End Points Details:

**Sessions**

- Create: Login 
- URL : /api/login
- Method : POST
- Request params: 
```json
{"email":"<email>","password":"<password>"}
```
- Response:
```json
{
    "id": 4,
    "email": "test1@gmail.com",
    "username": "test1",
    "role": "member",
    "authentication_token": "3c4b40046f94c02accc9c76383cbd67ac4e75121"
}
```

- Destroy: Logout
- URL : /api/logout/:authentication_token
- Method : DELETE
- Request params: - IN URL
- Response:
```json
{
    "result": {
        "messages": "ok",
        "rstatus": 1,
        "errorcode": ""
    },
    "data": {
        "messages": "Logout Successfully!"
    }
}
```

**Registrations**

- Create: Signup
- URL: /api/sign_up
- Method: POST
- Request params:
```json
{
  "user": {
    "email": "test1.freedom@gmail.com",
    "password": "testing123",
    "password_confirmation": "testing123",
    "username": "test1"
  }
}
```
**Lists**

- Create
- URL: /api/lists
- Method: POST
- Request Params:
```json
{
 "authentication_token": "9643bdab5f61b8396e2dfa832aa1073385d8fbb6",
  "list": {
    "title": "todos"
  }
}
```
- Response:
```json
{
    "id": 36,
    "title": "todos"
}
```

- Update
- URL: /api/lists/:id
- Method: PUT
- Request Params:
```json
{
 "authentication_token": "9643bdab5f61b8396e2dfa832aa1073385d8fbb6",
  "list": {
    "title": "todos"
  }
}
```
- Response:
```
{
    "id": 36,
    "title": "todos"
}
```
- Index
- URL: /api/lists?authentication_token=b7bc119ebb846e781777dbf21e73bb2eceaebac4
- Method: GET
- Request Params: - IN URL
- Response:
```json
[
    {
        "id": 23,
        "title": "todos"
    }
]
```
- Show
- URL: /api/lists/:id?authentication_token=b7bc119ebb846e781777dbf21e73bb2eceaebac4
- Method: GET
- Request Params: - In URL
- Response: 
```json
{
    "id": 23,
    "title": "todos",
    "cards": [],
    "list_owner": {
        "id": 4,
        "email": "shreya.freedom@gmail.com",
        "username": "shreyajhala",
        "role": "member"
    }
}
```
- Destroy
- URL: /api/lists/:id?authentication_token=b7bc119ebb846e781777dbf21e73bb2eceaebac4
- Method: DELETE
- Request Params: - IN URL
- Response:
```json
{
    "result": {
        "messages": "List deleted Successfully",
        "rstatus": 0,
        "errorcode": 404
    }
}
```
