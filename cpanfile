requires "HTTP::Throwable::Factory" => "0";
requires "Kavorka" => "0";
requires "Moose" => "0";
requires "Moose::Role" => "0";
requires "OX" => "0";
requires "common::sense" => "0";
requires "DateTime::HiRes" => "0";
requires "DateTime::Format::Strptime" => "0";
requires "lib" => "0";
requires "namespace::sweep" => "0";
requires "perl" => "v5.18.0";
requires "Config::General";
requires "LWP::Protocol::https";
requires "Log::Dispatch";
requires "Log::Dispatch::Message::Passing";
requires "Message::Passing";
requires "WebService::Trello" => "0.0301";
requires "WebService::FogBugz::XML" => "1.0200";
requires "Starman";
requires "Sys::Hostname::FQDN";

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.30";
};
