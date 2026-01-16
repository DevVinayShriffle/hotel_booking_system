class Validation
	def email_validation(email)
		email_regex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
		result = email.match(email_regex)

		if(!result)
			return false
		else
			return true
		end
	end

	def password_validation(password)
		password_regex = /[A-Z](?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{5,7}$/
		result = password.match(password_regex)
		if(!result)
			return false
		else
			return true
		end
	end

	def role_validation(role)
		puts role
		if(["manager", "customer"].include?(role))
			return true
		else
			return false
		end
	end
end