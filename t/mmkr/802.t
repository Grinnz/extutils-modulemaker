    {
        # suppress Personal::Defaults for duration of test
        # do not provide -t option
        # hence, you are testing against EU::MM::Defaults, which means you
        # must supply a NAME; you must also suppress interactive mode

        $tdir = tempdir( CLEANUP => 1);
        ok(chdir $tdir, 'changed to temp directory for testing');

        my $mmkr_dir_ref = _preexists_mmkr_directory();
        my $mmkr_dir = _make_mmkr_directory($mmkr_dir_ref);
        ok( $mmkr_dir, "personal defaults directory now present on system");

        my $pers_file = "ExtUtils/ModuleMaker/Personal/Defaults.pm";
        my $pers_def_ref = 
            _process_personal_defaults_file( $mmkr_dir, $pers_file );

        ok(! system(qq{$^X -I"$cwd/blib/lib" "$cwd/blib/script/modulemaker" -In My::Research::Module }), 
            "able to call modulemaker utility");

        $topdir = "My/Research/Module"; 
        ok(-d $topdir, "by default, non-compact top directory created");
        ok(-f "$topdir/$_", "$_ file created")
            for qw| Changes LICENSE MANIFEST Makefile.PL README Todo |;
        ok(-d "$topdir/$_", "$_ directory created")
            for qw| lib t |;
        
        @pred = (
            "My::Research::Module",
            "lib\/My\/Research\/Module\.pm",
            "A\.\\sU\.\\sThor",
            "a\.u\.thor\@a\.galaxy\.far\.far\.away",
            "Module\\sabstract\\s\\(<=\\s44\\scharacters\\)\\sgoes\\shere",
        );

        check_MakefilePL($topdir, \@pred);

        _reprocess_personal_defaults_file($pers_def_ref);

        ok(chdir $cwd, 'changed back to original directory after testing');

        ok( _restore_mmkr_dir_status($mmkr_dir_ref),
            "original presence/absence of .modulemaker directory restored");

    }


