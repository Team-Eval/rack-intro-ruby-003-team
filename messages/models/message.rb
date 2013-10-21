class Message
  include DataMapper::Resource

  property :id, Serial            # Auto-increment integer id
  property :to, String            # The sender of the message
  property :from, String          # Receiver of the message
  property :content, Text         # Message content
  property :created_at, DateTime  # Auto assigns date/time

end
