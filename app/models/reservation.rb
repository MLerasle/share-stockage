class Reservation < ActiveRecord::Base
  belongs_to :user
  belongs_to :advert
  default_value_for :validated, false
  validates :start_date, presence: true
  validates :end_date, presence: true

  class << self
    def json_format
      reservations = []
      self.all.each do |reservation|
        reservations << { title: reservation.validated ? 'Réservé' : 'En attente', start: reservation.start_date, end: reservation.end_date + 1.day, allDay: true }
      end
      reservations
    end
  
    def pending
      where(validated: false)
    end
  
    def pending_or_running
      where("(reservations.validated = ?) or (reservations.validated = ? and end_date >= ?)", false, true, Date.today)
    end
  end
  
  def duration
    (end_date - start_date + 1).to_i
  end
  
  def price
  	advert.daily_price * duration
  end
  
  def email_ask
    body = "Bonjour,\n\nVous avez reçu une demande de réservation de la part de #{self.user.username}\n\nAccédez dès maintenant à votre espace propriétaire pour valider ou annuler cette réservation.\n\nMeilleures salutations,\nSharing Space"
    subject = "Demande de réservation pour l'espace #{self.advert.title}"
    { body: body, subject: subject }
  end

  def email_validate
    body = "Bonjour,\n\nVotre réservation pour l'espace #{self.advert.title} a été acceptée par le propriétaire.\n\nVous recevrez l'un et l'autre un email contenant un exemplaire du contrat de location prérempli.\n\nVous pourrez alors convenir d'un rendez-vous avec le propriétaire pour déposer vos affaires.\n\nMeilleures salutations,\nSharing Space"
    subject = "Validation de la réservation pour l'espace #{self.advert.title}"
    { body: body, subject: subject }
  end

  def email_cancel
    body = "Bonjour,\n\nVotre réservation pour l'espace #{self.advert.title} a été annulée par le propriétaire.\n\nVous pouvez contacter le propriétaire pour en savoir plus en vous rendant sur la page de l'annonce ou rechercher un autre espace dès à présent.\n\nMeilleures salutations,\nSharing Space"
    subject = "Annulation de la réservation pour l'espace #{self.advert.title}"
    { body: body, subject: subject }
  end

  def email_update
    body = "Bonjour,\n\n#{self.user.username} a mis à jour les dates de sa réservation de votre espace.\n\nSi celles-ci vous conviennent, vous pouvez dès à présent valider la réservation depuis votre espace propriétaire.\n\nMeilleures salutations,\nSharing Space"
    subject = "Changement de dates de la réservation pour l'espace #{self.advert.title}"
    { body: body, subject: subject }
  end
end
