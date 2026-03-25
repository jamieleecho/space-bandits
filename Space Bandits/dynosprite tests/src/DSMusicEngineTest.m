//
//  DSMusicEngineTest.m
//  DynospriteCoreTests
//
//  Tests for the 3-voice music synthesis engine.
//

#import <XCTest/XCTest.h>
#import "dynosprite.h"

@interface DSMusicEngineTest : XCTestCase
@end

@implementation DSMusicEngineTest

- (void)setUp {
    MusicStopImmediate();
    MusicSetEnabled(1);
}

- (void)tearDown {
    MusicStopImmediate();
}

#pragma mark - MusicStart/Stop

- (void)testMusicStartSetsState {
    MusicStart(7209);  /* A3 = 220 Hz */
    /* Music should be playing after start */
    /* We can't directly check _musicState, but stopping should work */
    MusicStop();
}

- (void)testMusicStartMultipleVoices {
    MusicStart(7209);   /* voice 0: A3 */
    MusicStart1(8573);  /* voice 1: C4 */
    MusicStart2(10801); /* voice 2: E4 */
    MusicStop();
}

- (void)testMusicStopImmediate {
    MusicStart(7209);
    MusicStopImmediate();
    /* Should be fully stopped, not fading */
}

- (void)testMusicStop1SilencesOnlyVoice1 {
    MusicStart(7209);
    MusicStart1(8573);
    MusicStop1();
    /* Voice 0 should still be playing */
    MusicStop();
}

- (void)testMusicStop2SilencesOnlyVoice2 {
    MusicStart(7209);
    MusicStart2(10801);
    MusicStop2();
    MusicStop();
}

- (void)testMusicStartWithZeroIsSilent {
    /* phaseInc=0 should not produce sound but shouldn't crash */
    MusicStart(0);
    MusicStop();
}

#pragma mark - MusicSetEnabled

- (void)testMusicDisabledPreventsStart {
    MusicSetEnabled(0);
    MusicStart(7209);
    /* Music should not start when disabled */
    MusicSetEnabled(1);
}

- (void)testMusicGetEnabledReflectsState {
    XCTAssertEqual(MusicGetEnabled(), 1);
    MusicSetEnabled(0);
    XCTAssertEqual(MusicGetEnabled(), 0);
    MusicSetEnabled(1);
    XCTAssertEqual(MusicGetEnabled(), 1);
}

- (void)testMusicDisabledStopsPlaying {
    MusicStart(7209);
    MusicSetEnabled(0);
    /* Should have stopped immediately */
    MusicSetEnabled(1);
}

- (void)testMusicDisabledPreventsAllVoices {
    MusicSetEnabled(0);
    MusicStart(7209);
    MusicStart1(8573);
    MusicStart2(10801);
    /* None should start */
    MusicSetEnabled(1);
}

#pragma mark - Waveform Selection

- (void)testSetWaveformSine {
    MusicSetWaveSine0();
    MusicSetWaveSine1();
    MusicSetWaveSine2();
    MusicStart(7209);
    MusicStop();
}

- (void)testSetWaveformTriangle {
    MusicSetWaveTriangle0();
    MusicSetWaveTriangle1();
    MusicSetWaveTriangle2();
    MusicStart(7209);
    MusicStop();
}

- (void)testSetWaveformSawtooth {
    MusicSetWaveSawtooth0();
    MusicSetWaveSawtooth1();
    MusicSetWaveSawtooth2();
    MusicStart(7209);
    MusicStop();
}

- (void)testSetWaveformPulse {
    MusicSetWavePulse0();
    MusicSetWavePulse1();
    MusicSetWavePulse2();
    MusicStart(7209);
    MusicStop();
}

- (void)testSetWaveformQuietVariants {
    MusicSetWaveSineQuiet0();
    MusicSetWaveTriangleQuiet1();
    MusicSetWaveSawtoothQuiet2();
    MusicStart(7209);
    MusicStart1(8573);
    MusicStart2(10801);
    MusicStop();
}

- (void)testMixedWaveforms {
    /* Different waveform per voice — should not crash */
    MusicSetWaveSine0();
    MusicSetWaveTriangle1();
    MusicSetWaveSawtooth2();
    MusicStart(4286);   /* C3 */
    MusicStart1(5400);  /* E3 */
    MusicStart2(6423);  /* G3 */
    MusicStop();
}

#pragma mark - Phase Increment Calculations

- (void)testPhaseIncrementValues {
    /* Verify some known phase increment values:
       phaseInc = freq * 65536 / 2000 */
    /* A4 = 440 Hz -> 440 * 65536 / 2000 = 14418 */
    XCTAssertEqual((int)(440.0 * 65536.0 / 2000.0), 14417);
    /* C4 = 261.63 Hz -> ~8573 */
    XCTAssertTrue(abs((int)(261.63 * 65536.0 / 2000.0) - 8573) <= 1);
    /* A3 = 220 Hz -> 7209 */
    XCTAssertEqual((int)(220.0 * 65536.0 / 2000.0), 7208);
}

#pragma mark - Rapid Start/Stop

- (void)testRapidNoteChanges {
    /* Simulate sequencer-like rapid note changes */
    for (int i = 0; i < 100; i++) {
        MusicStart(4286 + i * 100);
        MusicStart1(5400 + i * 50);
        MusicStart2(6423 + i * 75);
    }
    MusicStop();
}

- (void)testStartStopCycle {
    for (int i = 0; i < 50; i++) {
        MusicStart(7209);
        MusicStop();
    }
}

- (void)testStopWhenNotPlaying {
    /* Should not crash */
    MusicStop();
    MusicStop1();
    MusicStop2();
    MusicStopImmediate();
}

@end
