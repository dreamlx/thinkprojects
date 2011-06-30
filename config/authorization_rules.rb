authorization do
  role :guest do
    has_permission_on :users, :to => [:read_index,:create,:read_show]
    
  end

  role :employee do
    includes :guest
    has_permission_on :users, :to => [:read_show,:update] do
      if_attribute :id => is {user.id}
    end
    has_permission_on [:billings,:personalcharges], :to => [:manage]
    has_permission_on [:projects], :to => [:read_index,:create,:read_show]

  end

  role :manager do
    includes :employee
    has_permission_on [:expenses], :to => [:manage]
    has_permission_on [:projects],:to=>[:manage]
    has_permission_on [:personalcharges], :to => [:approval,:disapproval] 
  end

  role :director do
    includes :manager
    has_permission_on [:projects],:to=>[:approval,:disapproval ,:manage,:close,:transform]

  end
  
  role :providence_breaker do
    includes :director
    has_permission_on [:users,:people,:clients,:personalcharges], :to => :manage
    has_permission_on [:projects],:to=>[:close,:transform,:manage]
  end
end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :read_index, :includes => :index
  privilege :read_show, :includes => :show
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy

  privilege :close, :includes => :close
  privilege :transform, :includes => :transform
  privilege :approval, :includes => :approval
  privilege :disapproval, :includes => :disapproval
end
