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
        post.published? && post.live?
      end
    end

    def normal
      anonymous
    end

    def editor
      can :manage, :all
      can :manage, User do |u|
        u == @user
      end
      cannot :index, User
    end

    def contributor
      can :manage, Post do |post|
        post.author == @user
      end

      can :manage, Slideshow do |slideshow|
        slideshow.author == @user
      end

      can :manage, Slide do |slide|
        can?(:manage, slide.slideshow)
      end

      can :read, Post

      cannot :manage, User
      cannot :manage, Column
      cannot :manage, Site
    end

    def admin
      can :manage, :all
    end

    def superuser
      can :manage, :all
    end
  end
end
