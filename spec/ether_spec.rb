require 'spec_helper'

describe Ether do
  describe '#initialize' do
    describe 'without arguments' do
      it 'should set socket correctly' do
        ether = Ether.new
        expect(ether.socket.class).to eq(Celluloid::IO::UDPSocket)
        expect(ether.socket.class).not_to eq(::UDPSocket)
        expect(ether.address_family).to eq(Socket::AF_INET6)
      end
    end

    describe 'with ordinary UDPSocket' do
      it 'should set socket correctly' do
        ether = Ether.new(socket_class: ::UDPSocket)
        expect(ether.socket.class).to eq(::UDPSocket)
        expect(ether.socket.class).not_to eq(Celluloid::IO::UDPSocket)
        expect(ether.address_family).to eq(Socket::AF_INET6)
      end
    end
  end

  describe '#from_host' do
    it 'should set address family correctly for ipv6' do
      ether = Ether.from_host('::1')
      expect(ether.address_family).to eq(Socket::AF_INET6)
      expect(ether.address_family).not_to eq(Socket::AF_INET)
    end

    it 'should set address family correctly for ipv4' do
      ether = Ether.from_host('127.0.0.1')
      expect(ether.address_family).to eq(Socket::AF_INET)
      expect(ether.address_family).not_to eq(Socket::AF_INET6)
    end
  end

  describe '.send' do
    it 'should resolve' do
      expect { Ether.send('hello', '127.0.0.1') }.not_to raise_error
      expect { Ether.send('hello', '::1') }.not_to raise_error
      expect { Ether.send('hello', 'ipv4.orgizm.net') }.not_to raise_error
      expect { Ether.send('hello', 'orgizm.net') }.not_to raise_error
      expect { Ether.send('hello', '.') }.to raise_error(Resolv::ResolvError)
    end
  end
end
