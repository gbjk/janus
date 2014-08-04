requires "HTTP::Throwable::Factory" => "0";
requires "Kavorka" => "0";
requires "Moose" => "0";
requires "Moose::Role" => "0";
requires "OX" => "0";
requires "common::sense" => "0";
requires "lib" => "0";
requires "namespace::sweep" => "0";
requires "perl" => "v5.18.0";
requires "Config::General";
requires "LWP::Protocol::https";
requires "WebService::Trello" => "0.0301";
requires "WebService::FogBugz::XML" => "1.0200";
requires "Starman";

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.30";
};
