class FindZiombies
  attr_accessor :initial_scope

  def initialize(initial_scope)
    @initial_scope = initial_scope
  end

  def call(params)
    scoped = search(initial_scope, params[:search])
    scoped = filter_by_weapons(scoped, params[:weapon_id])
    scoped = filter_by_armor(scoped, params[:armor_id])
    scoped
  end

  private

  def search(scoped, query = nil)
    if query
      scoped.full_search(query)
    else
      scoped
    end
  end

  def filter_by_weapons(scoped, properties = nil)
    if properties
      weapons = properties.split(',')
      weapons = Weapon.where(id: [weapons])
      scoped.joins(:zombie_weapons).merge(ZombieWeapon.where(weapon_id: [weapons])).distinct
    else
      scoped
    end
  end

  def filter_by_armor(scoped, properties = nil)
    if properties
      armors = properties.split(',')
      armors = Armor.where(id: [armors])
      scoped.joins(:zombie_armors).merge(ZombieArmor.where(armor_id: [armors])).distinct
    else
      scoped
    end
  end
end
