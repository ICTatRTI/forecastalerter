class User < ApplicationRecord

   #Validations
   validates_presence_of :email, :password_digest
   validates :email, uniqueness: true
 
   #encrypt password
   has_secure_password

   after_initialize :init
   def init
      self.password  ||= "1234thumbwar"           
    end

end
