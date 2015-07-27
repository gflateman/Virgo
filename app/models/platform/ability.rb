# note: role inheritence implemented via Ryan Bates' method
# outlined in https://github.com/ryanb/cancan/wiki/Role-Based-Authorization
module Platform
  class Ability
    include CanCan::Ability

    def initialize(user)
      @user = user || User.new # for guest

      send(@user.role) if @user.role.present?
    end

    def anonymous
      can :read, Post do |post|
        post.published? && post.live
      end
    end

    def normal
      anonymous
    end

    def editor
      can :manage, :all
      can :manage, Platform::User do |u|
        u == @user
      end
      cannot :index, Platform::User
    end

    def contributor
      can :manage, Platform::Post do |post|
        post.author == @user
      end

      can :manage, Platform::Slideshow do |slideshow|
        slideshow.author == @user
      end

      can :manage, Platform::Slide do |slide|
        can?(:manage, slide.slideshow)
      end

      can :read, Platform::Post

      cannot :manage, Platform::User
      cannot :manage, Platform::Column
      cannot :manage, Platform::Site
    end

    def admin
      can :manage, :all
    end

    def superuser
      can :manage, :all
    end
  end
end
