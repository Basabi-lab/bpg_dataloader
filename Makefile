NIMDA_GOOGLE_DRIVE := 'https://drive.google.com/uc?export=download&id=1w4n0ZY_i9Qk7LWxKjkENim0NOMA1_uAZ'
SLAMMER_GOOGLE_DRIVE := 'https://drive.google.com/uc?export=download&id=12AASaRnlPutW9knZs23nkBepLa7T2hAd'
CODEREDI_GOOGLE_DRIVE := 'https://drive.google.com/uc?export=download&id=1K29IKA8vucH3Nyzr3UbZfGlLTUdEZp_E'
EACH_MINUTE := ./datasets/each_minute
MERGED := ./datasets/merged
RAW := ./datasets/raw
EXTRACTED := ./datasets/extracted

RUBY := `which ruby`

TMP := ./tmp

setup: make_dir get_raw

make_dir:
	mkdir -p $(EACH_MINUTE)
	mkdir -p $(MERGED)
	mkdir -p $(EXTRACTED)
	mkdir -p $(RAW)

get_raw:
	mkdir -p $(TMP)
	wget $(NIMDA_GOOGLE_DRIVE) -O $(TMP)/nimda.zip
	wget $(SLAMMER_GOOGLE_DRIVE) -O $(TMP)/slammer.zip
	wget $(CODEREDI_GOOGLE_DRIVE) -O $(TMP)/coderedi.zip
	unzip $(TMP)/nimda.zip -d $(RAW)
	unzip $(TMP)/slammer.zip -d $(RAW)
	unzip $(TMP)/coderedi.zip -d $(RAW)
	$(RM) -rf $(TMP)

merge:
	$(RUBY) scripts/merge.rb

each_minute:
	$(RUBY) scripts/each_minute.rb

extract:
	$(RUBY) scripts/extract.rb

test:
	$(RUBY) tests/bgp_data_test.rb
	$(RUBY) tests/extract_test.rb
