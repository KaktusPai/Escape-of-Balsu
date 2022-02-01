using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterState : MonoBehaviour
{
    virtual public CharacterState handleInput() 
    {
        return this;
    }
}
