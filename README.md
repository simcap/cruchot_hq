## Flow

When signup occurs on customer application the cruchot client will do

    POST /confirm  params: {email: 'ludovic@mail.com'}
    200 OK
    { 
      email: 'ludovic@mail.com',
      message: 'En attente de confirmation de votre email'
    }

When user logs in for the first time

    GET /confirm?email=ludovic@mail.com
    200 OK  # User has been confirmed

## Hook

The application can provide an HTTP hook to be notified when email is confirmed

    POST /confirm  params: {email: 'ludovic@mail.com', notification: 'http://myhook.com/notify'}

## Examples

Signup

    def signup
      ...
      User.create!(email: 'ludovic@mail.com')
      Cruchot.confirm(email)
      ...
    end

Logs in

    def login
      ...
      if user.validated?
        render :login
      else
        Cruchot.


