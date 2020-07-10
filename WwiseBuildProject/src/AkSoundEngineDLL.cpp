//////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2006 Audiokinetic Inc. / All Rights Reserved
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "AkSoundEngineDLL.h"
#include <AK/Tools/Common/AkAssert.h>
#include <malloc.h>

#include <AK/SoundEngine/Common/AkMemoryMgr.h>
#include <AK/SoundEngine/Common/IAkStreamMgr.h>
#include "AkDefaultIOHookBlocking.h"
#ifndef AK_OPTIMIZED
#include <AK/Comm/AkCommunication.h>
#endif

#include <AK/Plugin/AllPluginsRegistrationHelpers.h>
#include <AK/SoundEngine/Common/AkQueryParameters.h>

// Defines.

// Default memory manager settings.
#define COMM_POOL_SIZE			(256 * 1024)
#define COMM_POOL_BLOCK_SIZE	(48)

namespace AK
{
  void * AllocHook(size_t in_size)
  {
    return malloc(in_size);
  }
  void FreeHook(void * in_ptr)
  {
    free(in_ptr);
  }
  void * VirtualAllocHook(
    void * in_pMemAddress,
    size_t in_size,
    DWORD in_dwAllocationType,
    DWORD in_dwProtect
    )
  {
    return VirtualAlloc(in_pMemAddress, in_size, in_dwAllocationType, in_dwProtect);
  }
  void VirtualFreeHook(
    void * in_pMemAddress,
    size_t in_size,
    DWORD in_dwFreeType
    )
  {
    VirtualFree(in_pMemAddress, in_size, in_dwFreeType);
  }

#ifdef AK_XBOX360
  void * PhysicalAllocHook(
    size_t in_size,					///< Number of bytes to allocate
    ULONG_PTR in_ulPhysicalAddress, ///< Parameter for XPhysicalAlloc
    ULONG_PTR in_ulAlignment,		///< Parameter for XPhysicalAlloc
    DWORD in_dwProtect				///< Parameter for XPhysicalAlloc
    )
  {
    return XPhysicalAlloc(in_size, in_ulPhysicalAddress, in_ulAlignment, in_dwProtect);
  }
  void PhysicalFreeHook(
    void * in_pMemAddress	///< Pointer to start of memory allocated with PhysicalAllocHook
    )
  {
    XPhysicalFree(in_pMemAddress);
  }
#endif

#ifdef AK_XBOXONE
  void * APUAllocHook(
    size_t in_size,				///< Number of bytes to allocate.
    unsigned int in_alignment	///< Alignment in bytes (must be power of two, greater than or equal to four).
    )
  {
    void * pReturn = nullptr;
    //		ApuAlloc( &pReturn, NULL, (UINT32) in_size, in_alignment );
    return pReturn;
  }

  void APUFreeHook(
    void * in_pMemAddress	///< Virtual address as returned by APUAllocHook.
    )
  {
    //ApuFree( in_pMemAddress );
  }
#endif

  namespace SOUNDENGINE_DLL
  {
	  CAkDefaultIOHookBlocking  m_lowLevelIO;

    //-----------------------------------------------------------------------------------------
    // Sound Engine initialization.
    //-----------------------------------------------------------------------------------------

  }

#if defined AK_XBOX360 || defined AK_XBOXONE
  BOOL APIENTRY DllMain(HANDLE hModule,
    DWORD  ul_reason_for_call,
    LPVOID lpReserved)
  {
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
      break;
    case DLL_THREAD_ATTACH:
      break;
    case DLL_THREAD_DETACH:
      break;
    case DLL_PROCESS_DETACH:
      break;

    }
    return TRUE;
  }
#endif


  extern "C"
  {
    __declspec(dllexport) AKRESULT AK_SOUNDDLL_Init(bool connect_to_wwise)
    {
      // Initialize the memory manager of Wwise.
      AkMemSettings memSettings;
      memSettings.uMaxNumPools = 20;
      // Initialize the stream manager.
      AkStreamMgrSettings stmSettings;
      AK::StreamMgr::GetDefaultSettings(stmSettings);
      AkDeviceSettings deviceSettings;
      AK::StreamMgr::GetDefaultDeviceSettings(deviceSettings);


      // Initialize the sound engine.
      AkInitSettings initSettings;
      AkPlatformInitSettings platformInitSettings;
      AK::SoundEngine::GetDefaultInitSettings(initSettings);
      AK::SoundEngine::GetDefaultPlatformInitSettings(platformInitSettings);

      // Initialize the music engine.
      AkMusicSettings musicInit;
      AK::MusicEngine::GetDefaultInitSettings(musicInit);

	  // Create and initialise an instance of our memory manager.
	  if (MemoryMgr::Init(&memSettings) != AK_Success)
	  {
		  AKASSERT(!"Could not create the memory manager.");
		  return AK_Fail;
	  }

	  // Create and initialise an instance of the default stream manager.
	  if (!StreamMgr::Create(stmSettings))
	  {
		  AKASSERT(!"Could not create the Stream Manager");
		  return AK_Fail;
	  }

	  // Create an IO device.
	  if (AK::SOUNDENGINE_DLL::m_lowLevelIO.Init(deviceSettings) != AK_Success)
	  {
		  AKASSERT(!"Cannot create streaming I/O device");
		  return AK_Fail;
	  }

	  // Initialize sound engine.
	  if (SoundEngine::Init(&initSettings, &platformInitSettings) != AK_Success)
	  {
		  AKASSERT(!"Cannot initialize sound engine");
		  return AK_Fail;
	  }

	  // Initialize music engine.
	  if (MusicEngine::Init(&musicInit) != AK_Success)
	  {
		  AKASSERT(!"Cannot initialize music engine");
		  return AK_Fail;
	  }

#ifndef AK_OPTIMIZED
	  // Initialize communication.
	  AkCommSettings settingsComm;
	  AK::Comm::GetDefaultInitSettings(settingsComm);
	  if (AK::Comm::Init(settingsComm) != AK_Success)
	  {
		  AKASSERT(!"Cannot initialize communication");
		  return AK_Fail;
	  }
#endif // AK_OPTIMIZED

#ifdef AK_APPLE
      AK::SoundEngine::RegisterCodec(
        AKCOMPANYID_AUDIOKINETIC,
        AKCODECID_AAC,
        CreateAACFilePlugin,
        CreateAACBankPlugin);
#endif

#ifdef AK_VITA
      AK::SoundEngine::RegisterCodec(
        AKCOMPANYID_AUDIOKINETIC,
        AKCODECID_ATRAC9,
        CreateATRAC9FilePlugin,
        CreateATRAC9BankPlugin);
#endif			

      return AK_Success;
    }

    //-----------------------------------------------------------------------------------------
    // Sound Engine termination.
    //-----------------------------------------------------------------------------------------
    __declspec(dllexport) void AK_SOUNDDLL_Term()
    {
#ifndef AK_OPTIMIZED
		Comm::Term();
#endif // AK_OPTIMIZED

		MusicEngine::Term();

		SoundEngine::Term();

		AK::SOUNDENGINE_DLL::m_lowLevelIO.Term();
		if (IAkStreamMgr::Get())
			IAkStreamMgr::Get()->Destroy();

		MemoryMgr::Term();
    }

    //-----------------------------------------------------------------------------------------
    // Sound Engine periodic update.
    //-----------------------------------------------------------------------------------------
    __declspec(dllexport) void AK_SOUNDDLL_Tick()
    {
      SoundEngine::RenderAudio( );
    }

    //-----------------------------------------------------------------------------------------
    // Access to LowLevelIO's file localization.
    //-----------------------------------------------------------------------------------------
    // File system interface.
    __declspec(dllexport) AKRESULT AK_SOUNDDLL_SetBasePath(
      const AkOSChar*   in_pszBasePath
      )
    {
      return AK::SOUNDENGINE_DLL::m_lowLevelIO.SetBasePath(in_pszBasePath);
    }
    __declspec(dllexport) AKRESULT AK_SOUNDDLL_SetBankPath(
      const AkOSChar*   in_pszBankPath
      )
    {
      return AK::SOUNDENGINE_DLL::m_lowLevelIO.AddBasePath(in_pszBankPath);
    }
    __declspec(dllexport) AKRESULT AK_SOUNDDLL_SetAudioSrcPath(
      const AkOSChar*   in_pszAudioSrcPath
      )
    {
      return AK::SOUNDENGINE_DLL::m_lowLevelIO.AddBasePath(in_pszAudioSrcPath);
    }
  }
}

  AKRESULT AK_SOUNDDLL_LoadBank(const char *name, AkMemPoolId id, AkBankID &outBankId)
  {
    return AK::SoundEngine::LoadBank(name, id, outBankId);
  }

  AKRESULT AK_SOUNDDLL_RegisterGameObj(AkGameObjectID gameObjectID)
  {
    return AK::SoundEngine::RegisterGameObj(gameObjectID);
  }

  AKRESULT AK_SOUNDDLL_RegisterGameObjName(AkGameObjectID gameObjectID, const char * objectName)
  {
    return AK::SoundEngine::RegisterGameObj(gameObjectID, objectName);
  }

  AKRESULT AK_SOUNDDLL_UnregisterGameObj(AkGameObjectID id)
  {
    return AK::SoundEngine::UnregisterGameObj(id);
  }

  AkPlayingID AK_SOUNDDLL_PostEvent(const char *name, AkGameObjectID id)
  {
    return AK::SoundEngine::PostEvent(name, id, AK_EnableGetSourcePlayPosition);
  }

  void AK_SOUNDDLL_StopPlayingID(AkPlayingID id, AkTimeMs transDur)
  {
    AK::SoundEngine::StopPlayingID(id, transDur);
  }

  AKRESULT AK_SOUNDDLL_SetRTPCValue(const char *name, AkRtpcValue value, AkGameObjectID id)
  {
    return AK::SoundEngine::SetRTPCValue(name, value, id);
  }

  AKRESULT AK_SOUNDDLL_SetRTPCValueGlobal(const char *name, AkRtpcValue value)
  {
    return AK::SoundEngine::SetRTPCValue(name, value);
  }

  AKRESULT AK_SOUNDDLL_SetSwitch(const char *switchGroup, const char *switchState, AkGameObjectID id)
  {
    return AK::SoundEngine::SetSwitch(switchGroup, switchState, id);
  }

  AKRESULT AK_SOUNDDLL_SetState(const char *stateGroup, const char *state)
  {
    return AK::SoundEngine::SetState(stateGroup, state);
  }

  AKRESULT AK_SOUNDDLL_SeekEvent(AkUniqueID id, AkGameObjectID gObjId, AkTimeMs pos)
  {
	  return AK::SoundEngine::SeekOnEvent(id, gObjId, pos);
  }

  AkUniqueID AK_SOUNDDLL_GetEventIdFromPlayingId(AkPlayingID id)
  {
	  return AK::SoundEngine::Query::GetEventIDFromPlayingID(id);
  }

  AkTimeMs AK_SOUNDDLL_GetSourceTime(AkPlayingID id)
  {
	  AkTimeMs time;
	  AK::SoundEngine::GetSourcePlayPosition(id, &time);
	  return time;
  }
