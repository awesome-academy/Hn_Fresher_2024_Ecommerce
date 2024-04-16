class Admin::UsersController < Admin::AdminController
  include Admin::UsersHelper
  before_action :load_users, only: :index
  before_action :load_user, :prevent_self_update, only: %i(update destroy)
  def index; end

  def update
    unless @user
      return redirect_to admin_users_path, flash: {
        danger: t("pages.account.update.fail")
      }
    end

    update_role if params[:type] == "role"
    update_status if params[:type] == "status"
    redirect_to admin_users_path
  end

  def destroy
    return unless @user

    if @user.destroy
      flash[:success] = t "pages.account.delete.success"
    else
      flash[:danger] = t "pages.account.delete.fail"
    end
    redirect_to admin_users_path
  end

  private

  def load_user
    @user = Account.find_by id: params[:id]
  end

  def load_users
    @pagy, @users = pagy(Account.without_sensitive_attributes
                                .order_by_created_at,
                         items: Settings.pagy.user.per_page)
  end

  def update_role
    if @user.update(is_admin: !@user.is_admin)
      flash[:success] = t "pages.account.update.success"
    else
      flash[:danger] = t "pages.account.update.fail"
    end
  end

  def update_status
    if @user.update(is_active: !@user.is_active)
      flash[:success] = t "pages.account.update.success"
    else
      flash[:danger] = t "pages.account.update.fail"
    end
  end

  def prevent_self_update
    return unless @user == current_account

    flash[:danger] = t("pages.account.update.cannot_update_self")
    redirect_to admin_users_path
  end
end
