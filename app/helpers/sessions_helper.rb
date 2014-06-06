module SessionsHelper

	# サインイン確認
	# @return [boolean] サインインしていればtrue
	def signed_in?
		!current_user.nil?
	end

	# カレントユーザーの取得
	# @return [User] カレントユーザー
	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
		@current_user
	end

	# サインインしてなければサインインページへ飛ばす
	def signed_in_user
		unless signed_in?
			redirect_to root_path
		end
	end
end
