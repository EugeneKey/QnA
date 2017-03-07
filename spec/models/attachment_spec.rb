# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { should belong_to :attachable }
end
