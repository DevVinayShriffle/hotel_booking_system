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
		password_regex = /^(?=.*[A-Z])(?=.*\W)(?!.* ).{6,8}$/
		result = password.match(password_regex)

		if(!result)
			return 0
		else
			return 1
		end
	end
end