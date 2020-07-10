//////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2006 Audiokinetic Inc. / All Rights Reserved
//
//////////////////////////////////////////////////////////////////////

#ifndef AK_SOUND_ENGINE_DLL_H_
#define AK_SOUND_ENGINE_DLL_H_

#include <AK/SoundEngine/Common/AkSoundEngine.h>
#include <AK/MusicEngine/Common/AkMusicEngine.h>
#include <AK/SoundEngine/Common/AkModule.h>
#include <AK/SoundEngine/Common/AkStreamMgrModule.h>

#define INCLUDE_FUNCTION(RETURN, NAME) __pragma( comment ( linker, "/INCLUDE:_"#NAME)) AKSOUNDENGINE_API RETURN NAME

extern "C"
{
  INCLUDE_FUNCTION(AKRESULT, AK_SOUNDDLL_Init)(bool connect_to_wwise);
  INCLUDE_FUNCTION(void, AK_SOUNDDLL_Term)();
  INCLUDE_FUNCTION(void, AK_SOUNDDLL_Tick)();

  // File system interface.
  INCLUDE_FUNCTION(AKRESULT, AK_SOUNDDLL_SetBankPath)(
    const AkOSChar*   in_pszBankPath
    );
  INCLUDE_FUNCTION(AKRESULT, AK_SOUNDDLL_SetAudioSrcPath)(
    const AkOSChar*   in_pszAudioSrcPath
    );

  //INCLUDE_FUNCTION(AKRESULT, AK_SOUNDDLL_SetLangSpecificDirName)(
  //  const AkOSChar*   in_pszDirName
  //  );

  INCLUDE_FUNCTION(AKRESULT, AK_SOUNDDLL_LoadBank)(const char *name, AkMemPoolId id, AkBankID &outBankId);

  INCLUDE_FUNCTION(AKRESULT, AK_SOUNDDLL_RegisterGameObj)(AkGameObjectID gameObjectID);

  INCLUDE_FUNCTION(AKRESULT, AK_SOUNDDLL_RegisterGameObjName)(AkGameObjectID gameObjectID, const char *name);

  INCLUDE_FUNCTION(AKRESULT, AK_SOUNDDLL_UnregisterGameObj)(AkGameObjectID id);

  INCLUDE_FUNCTION(AkPlayingID, AK_SOUNDDLL_PostEvent)(const char *name, AkGameObjectID id);

  INCLUDE_FUNCTION(void, AK_SOUNDDLL_StopPlayingID)(AkPlayingID id, AkTimeMs transDur);

  INCLUDE_FUNCTION(AKRESULT, AK_SOUNDDLL_SetRTPCValue)(const char *name, AkRtpcValue value, AkGameObjectID id);

  INCLUDE_FUNCTION(AKRESULT, AK_SOUNDDLL_SetRTPCValueGlobal)(const char *name, AkRtpcValue value);

  INCLUDE_FUNCTION(AKRESULT, AK_SOUNDDLL_SetSwitch)(const char *switchGroup, const char *switchState, AkGameObjectID id);

  INCLUDE_FUNCTION(AKRESULT, AK_SOUNDDLL_SetState)(const char *stateGroup, const char *state);
  
  INCLUDE_FUNCTION(AKRESULT, AK_SOUNDDLL_SeekEvent)(AkUniqueID id, AkGameObjectID gObjId, AkTimeMs pos);

  INCLUDE_FUNCTION(AkUniqueID, AK_SOUNDDLL_GetEventIdFromPlayingId)(AkPlayingID id);

  INCLUDE_FUNCTION(AkTimeMs, AK_SOUNDDLL_GetSourceTime)(AkPlayingID id);
}

#endif //AK_SOUND_ENGINE_DLL_H_
