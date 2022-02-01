using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Character : MonoBehaviour
{
    private CharacterState state;

    class IdleState : CharacterState 
    {
        public override CharacterState handleInput() 
        {
            if (Input.GetButtonDown("Jump"))
                return new JumpingState();
        }
    }
    class JumpingState : CharacterState 
    {
        public override CharacterState handleInput() 
        {
            return this;
        }
    }
}
