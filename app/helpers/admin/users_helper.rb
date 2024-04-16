module Admin::UsersHelper
  def render_user_role_link user
    current_role, new_role = user_role_texts user
    link_to current_role, admin_user_path(user, type: "role"),
            class: get_class_link(user.is_admin),
            data: {turbo_method: :put, turbo_confirm:
              t("pages.account.update.role", role: new_role)}
  end

  def render_user_status_link user
    current_status, new_status = user_status_texts user
    link_to current_status, admin_user_path(user, type: "status"),
            class: get_class_link(user.is_active),
            data: {turbo_method: :put,
                   turbo_confirm: t("pages.account.update.status",
                                    status: new_status)}
  end

  private

  def user_role_texts user
    if user.is_admin?
      [t("pages.account.role.admin"), t("pages.account.role.user")]
    else
      [t("pages.account.role.user"), t("pages.account.role.admin")]
    end
  end

  def user_status_texts user
    if user.is_active?
      [t("pages.account.status.active"), t("pages.account.status.inactive")]
    else
      [t("pages.account.status.inactive"), t("pages.account.status.active")]
    end
  end

  def get_class_link condition
    condition ? "btn btn-success" : "btn btn-danger"
  end
end
