using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using APIWithSql.Data;
using APIWithSql.Models;
using Microsoft.AspNetCore.Mvc;



namespace APIWithSql.Controllers
{
    [Route("api/[controller]")]
    public class SpeakerEvalController : Controller
    {
        private readonly iSpeakerEvalsRepository _repository;

        public SpeakerEvalController(iSpeakerEvalsRepository repository)
        {
            _repository = repository;
        }

        // GET api/speakereval
        [HttpGet]
        public IActionResult Get()
        {
            return Ok(_repository.GetAll().ToList());
        }

        // GET api/speakereval/3
        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id)
        {
            var entity = await _repository.FindAsync(id);
            if (entity == null)
                return NotFound();

            return Ok(entity);
        }

        // POST api/speakereval
        [HttpPost]
        public async Task<IActionResult> Post([FromBody]SpeakerEval model)
        {
            if (model == null)
                return BadRequest("Please provide a Session Evaluation.");
            if (string.IsNullOrEmpty(model.SessionName))
                return BadRequest("An session name is required.");

            var entity = await _repository.AddAsync(model);

            //return CreatedAtRoute(nameof(Get), entity.Id, entity);
            return StatusCode(201);
            //return new CreatedResult();
        }

        // PUT api/speakereval/3
        [HttpPut("{id}")]
        public async Task<IActionResult> Put(int id, [FromBody]SpeakerEval model)
        {
            if (model == null || model.Id != id)
            {
                return BadRequest();
            }

            var entity = await _repository.FindAsync(id);
            if (entity == null)
            {
                return NotFound();
            }

            await _repository.UpdateAsync(model);
            return new NoContentResult();
        }

        // DELETE api/speakereval/3
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            try
            {
                await _repository.RemoveAsync(id);
            }
            catch (InvalidOperationException e)
            {
                Console.WriteLine(e);
                return BadRequest("No SpeakerSession found with id " + id);
            }

            return new NoContentResult();
        }
    }
}
