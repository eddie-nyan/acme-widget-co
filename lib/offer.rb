# Base class for offer strategies
class Offer
  def apply(items, catalogue)
    raise NotImplementedError, "Subclasses must implement #apply"
  end
end