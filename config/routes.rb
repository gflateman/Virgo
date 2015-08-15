Virgo::Engine.routes.draw do
  root to: 'posts#index'
  get 'login', to: redirect('/users/sign_in')

  resources :posts, except: [:show] do
    get :track, on: :member
    get :popular, on: :collection
    get :more, on: :collection
  end

  resources :install do
    get :success, on: :collection
  end

  resources :columns
  resources :tags
  resources :search
  resources :users, path: '/author'
  resources :subscribers do
    match :modal, on: :collection, via: [:get, :post]
  end

  resources :page_modules do
    get '/popular_posts' => 'page_modules#popular_posts', on: :collection
  end

  get '/news' => 'posts#latest', as: :latest_posts
  get '/feed.rss' => 'posts#rss', as: :feed
  get '/feed.xml' => 'posts#rss', as: :feed_alt
  get '/authors' => 'pages#authors', as: :authors
  get '/admin/help' => 'admin/pages#help', as: :admin_help


  devise_for :users, class_name: "Virgo::User", controllers: {
    sessions: 'virgo/users/sessions',
    registrations: 'virgo/users/registrations',
    passwords: 'virgo/users/passwords',
    confirmations: 'virgo/users/confirmations'
  }

  namespace :admin do
    get '/admin/posts/revision_detail/:version_id' => 'posts#revision_detail', as: :revision_detail

    resources :media_modal do
      post :upload, on: :collection
      get :library_panel, on: :collection
      match :upload_panel, on: :collection, via: [:get, :post]
      match '/image_settings/:image_id' => 'media_modal#image_settings', on: :collection, via: [:get, :patch], as: :image_settings
    end

    resources :slideshows do
      resources :slides, shallow: true
    end

    post '/admin/slides/positions' => 'slides#positions'

    resources :posts do
      get :revisions, on: :member
      get :options, on: :collection
      get 'author_dropdown' => 'posts#author_dropdown', on: :collection
      match 'editing' => 'posts#editing', on: :member, via: [:get, :post]
      delete 'featured_image' => 'posts#delete_featured_image', on: :member
      delete 'thumbnail_image' => 'posts#delete_thumbnail_image', on: :member
      patch :tag_ordering, on: :member
      get :find, on: :collection
    end

    resources :columns

    get '/site/edit' => 'sites#edit'
    patch '/site' => 'sites#update'
    match '/site/styles' => 'sites#styles', via: [:get, :patch]

    get '/page_modules/edit' => 'page_modules#edit'
    patch '/page_modules' => 'page_modules#update'
    match '/page_modules/:id/edit_subject' => 'page_modules#edit_subject', via: [:get, :patch], as: :edit_page_module_subject
    get '/newsletter/edit' => 'newsletters#edit'
    patch '/newsletter' => 'newsletters#update'
    get '/newsletter/changelog' => 'newsletters#changelog'

    resources :tags do
      get 'modal_form', on: :collection
    end
    resources :categories do
      get 'modal_form', on: :collection
    end
    resources :users do
      resources :sessions, controller: 'users/sessions'
    end
    resources :images do
      post :upload, on: :collection
      get :embed, on: :member
    end
  end

  get '/sections/:id' => 'categories#show', as: :category
  get '/:id' => 'posts#show', as: :post_detail
end
