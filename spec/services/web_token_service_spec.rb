require 'rails_helper'

RSpec.describe WebTokenService do
  let(:payload) { { user_id: 1 } }
  let(:expired_token) { WebTokenService.encode(payload, 1.hour.ago) }
  let(:valid_token) { WebTokenService.encode(payload) }

  describe '.encode' do
    it 'retorna um token JWT válido' do
      token = WebTokenService.encode(payload)
      expect(token).to be_a(String)
    end

    it 'inclui o tempo de expiração no token' do
      exp = 10.hours.from_now
      token = WebTokenService.encode(payload, exp)
      decoded_token = WebTokenService.decode(token)
      expect(decoded_token[:exp]).to eq(exp.to_i)
    end
  end

  describe '.decode' do
    context 'quando o token é válido' do
      it 'decodifica o token e retorna o payload' do
        decoded_token = WebTokenService.decode(valid_token)
        expect(decoded_token[:user_id]).to eq(payload[:user_id])
      end
    end

    context 'quando o token está expirado' do
      it 'retorna nil' do
        decoded_token = WebTokenService.decode(expired_token)
        expect(decoded_token).to be_nil
      end
    end

    context 'quando o token é inválido' do
      it 'retorna nil' do
        invalid_token = 'invalid_token'
        decoded_token = WebTokenService.decode(invalid_token)
        expect(decoded_token).to be_nil
      end
    end
  end
end
