#staff/senior/manager/parnter/admin/superuser

authorization do
  role :guest do
    has_permission_on :users, :to             => [:read_index,:create,:read_show]

  end
  # 需要创建一个hr角色， 管理client/staff/projects, 只能创建不能删除

  role :staff do
    includes :guest
    has_permission_on :users, :to             => [:read_show,:update] do
      if_attribute :id                        => is {user.id}
    end
    has_permission_on [:personalcharges, :expenses], :to => [:create, :read] do
      if_attribute :person_id => is {user.person_id}
    end
    has_permission_on [:personalcharges, :expenses], :to => [:update, :delete] do
      if_attribute :person_id => is {user.person_id},:state  =>  ["disapproved","pending"]
    end
    has_permission_on [:projects], :to => [:read] do
      # 只能看自己的projects，model实现
    end

  end

  role :senior do
    includes :staff
  end


  role :hr_admin do
    includes :staff
    has_permission_on [:projects,:clients, :people], :to => [:create, :read, :update] 
    has_permission_on :users, :to             => [:read_show,:update] do
      if_attribute :id                        => is {user.id}
    end
    #  has_permission_on [:projects], :to => [:close, :transform] do
    #    if_attribute :state => "approved"
    #  end

  end

  role :partner do
    includes :manager
    includes :hr_admin
    has_permission_on [:personalcharges, :expenses], :to => [:approval, :disapproval, :batch_actions,:addcomment] do
      if_attribute :person_id                   => is_not {user.person_id},:state => "pending"
    end
    has_permission_on [:projects], :to => [:create, :read] do
      #if_attribute :manager_id => is {user.person_id}
    end
    has_permission_on [:projects], :to => [:update, :delete] do
      if_attribute :manager_id => is {user.person_id}, :state  => ["disapproved","pending"]
    end    
    has_permission_on [:projects], :to => [:batch_actions,:approval, :disapproval,:addcomment] do
      if_attribute :manager_id                   => is_not {user.person_id},:state => "pending"
    end

    has_permission_on [:projects], :to => [ :close] do
      if_attribute :manager_id => is {user.person_id},:state => "approved"
    end


  end



  role :providence_breaker do
    includes :partner
    has_permission_on [:projects,:personalcharges, :expenses, :users, :clients, :people], :to => [:manage] 

    has_permission_on [:projects], :to => [:close] do
      if_attribute :state => "approved"
    end
    has_permission_on [:personalcharges,:expenses, :projects], :to => [:transform] do
      if_attribute :state => "approved"
    end
    has_permission_on [:personalcharges, :expenses, :projects], :to => [:approval, :disapproval, :batch_actions,:addcomment] do
      if_attribute :state => "pending" 
    end
  end
  
  
  role :manager do
    includes :providence_breaker

  end
end

privileges do
  privilege :manage, :includes                => [:create, :read, :update, :delete]
  privilege :read, :includes                  => [:index, :show]
  privilege :read_index, :includes            => :index
  privilege :read_show, :includes             => :show
  privilege :create, :includes                => :new
  privilege :update, :includes                => :edit
  privilege :delete, :includes                => :destroy
  privilege :addcomment, :includes                 => :addcomment
  privilege :close, :includes                 => :close
  privilege :transform, :includes             => :transform
  privilege :approval, :includes              => :approval
  privilege :disapproval, :includes           => :disapproval
  privilege :batch_actions, :includes         => :batch_actions
end
